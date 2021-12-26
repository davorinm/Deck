import Foundation
import CoreBluetooth

enum BluetoothManagerState {
    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
    case scanning
    
    static func fromCBManagerState(state: CBManagerState) -> BluetoothManagerState {
        switch state {
        case .unknown:
            return .unknown
        case .resetting:
            return .resetting
        case .unsupported:
            return .unsupported
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        @unknown default:
            return .unknown
        }
    }
}

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private let centralManager: CBCentralManager
    private var discoveredPeripheralsCache = [UUID: BluetoothPeripheral]()
    
    let state: ObservableProperty<BluetoothManagerState>
    
    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: nil)
        state = ObservableProperty<BluetoothManagerState> (value: BluetoothManagerState.fromCBManagerState(state: centralManager.state))
        
        super.init()
        
        centralManager.delegate = self
    }
    
    func scanForPeripherals(withServices deviceServicesIdentifiers: [String] = [], options: [String : Any]? = nil) {
        if centralManager.state != .poweredOn {
            assertionFailure("Bluetooth is off")
            return
        }
        
        discoveredPeripheralsCache.removeAll()
        
        state.value = .scanning
        
        let serviceUUIDs = deviceServicesIdentifiers.map({ CBUUID(string: $0) })
        centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }
    
    func retrievePeripheral(deviceId: UUID?) -> BluetoothPeripheral? {
        if centralManager.state != .poweredOn {
            assertionFailure("Bluetooth is off")
            return nil
        }
        
        guard let deviceId = deviceId else {
            return nil
        }
        
        discoveredPeripheralsCache.removeAll()
        
        let peripherals = centralManager.retrievePeripherals(withIdentifiers: [deviceId])
        
        guard let peripheral = peripherals.first else {
            return nil
        }
        
        return BluetoothPeripheral(peripheral: peripheral, manager: self, rssi: -100)
    }
    
    func stopScanning() {
        guard centralManager.isScanning else {
            return
        }
        
        centralManager.stopScan()
        state.value = BluetoothManagerState.fromCBManagerState(state: centralManager.state)
    }
    
    func discoveredPeripherals() -> [BluetoothPeripheral] {
        return Array(discoveredPeripheralsCache.values)
    }
    
    func connect(_ bluetoothPeripheral: BluetoothPeripheral) {
        if discoveredPeripheralsCache[bluetoothPeripheral.identifier] == nil {
            discoveredPeripheralsCache[bluetoothPeripheral.identifier] = bluetoothPeripheral
        }
        
        centralManager.connect(bluetoothPeripheral.peripheral, options: nil)
        bluetoothPeripheral.state.value = .connecting
        
        cleanupDevices()
    }
    
    func cancelPeripheralConnection(_ bluetoothPeripheral: BluetoothPeripheral) {
        if let bluetoothPeripheral = discoveredPeripheralsCache[bluetoothPeripheral.identifier] {
            bluetoothPeripheral.state.value = .disconnecting            
            centralManager.cancelPeripheralConnection(bluetoothPeripheral.peripheral)
        }
    }
    
    private func cleanupDevices() {
        discoveredPeripheralsCache = discoveredPeripheralsCache.filter { (key, peripheral) -> Bool in
            return peripheral.state.value != .disconnected
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let bluetoothPeripheral = discoveredPeripheralsCache[peripheral.identifier] {
            bluetoothPeripheral.state.value = .connected
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let bluetoothPeripheral = discoveredPeripheralsCache.removeValue(forKey: peripheral.identifier) {
            bluetoothPeripheral.state.value = .disconnected
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let rssiD = RSSI.doubleValue
        
        if let bluetoothPeripheral = discoveredPeripheralsCache[peripheral.identifier] {
            bluetoothPeripheral.addRssiReading(rssiD)
        } else {
            discoveredPeripheralsCache[peripheral.identifier] = BluetoothPeripheral(peripheral: peripheral, manager: self, rssi: rssiD)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let bluetoothPeripheral = discoveredPeripheralsCache[peripheral.identifier] {
            bluetoothPeripheral.state.value = .disconnected
        }
        
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state.value = BluetoothManagerState.fromCBManagerState(state: central.state)
                
        if state.value == .poweredOff {
            discoveredPeripheralsCache.removeAll()
        }
    }
}
