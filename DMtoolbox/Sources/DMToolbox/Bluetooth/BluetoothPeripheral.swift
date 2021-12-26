import Foundation
import CoreBluetooth

protocol BluetoothPeripheralDelegate: AnyObject {
    func onUpdateValue(characteristic: BluetoothCharacteristic, data: Data?)
    func onWriteValue(characteristic: BluetoothCharacteristic)
    func onUpdateNotificationState(characteristic: BluetoothCharacteristic)
    func onFinishedScanningForCharacteristcs(sucess: Bool)
}

enum BluetoothPeripheralState {
    case disconnected
    case connecting
    case connected
    case disconnecting
}

class BluetoothPeripheral: NSObject, CBPeripheralDelegate {
    let peripheral: CBPeripheral
    private let manager: BluetoothManager
    var rssi: Double {
        get {
            let rssiSum = rssiReadings.reduce(0, +)
            return rssiSum / Double(rssiReadings.count)
        }
    }
    var identifier: UUID {
        return peripheral.identifier
    }

    let state: ObservableProperty<CBPeripheralState>
    
    private(set) var discoveredCharacteristics = [BluetoothCharacteristic]()
    private var serviceScanUUIDs: [CBUUID]?
    private var discoveredServices = [CBUUID]()
    private var rssiReadings: [Double]
    
    weak var delegate: BluetoothPeripheralDelegate?
    
    init(peripheral: CBPeripheral, manager: BluetoothManager, rssi: Double) {
        self.peripheral = peripheral
        self.manager = manager
        self.state = ObservableProperty<CBPeripheralState> (value: self.peripheral.state)
        
        self.rssiReadings = [rssi]
        
        super.init()
        
        self.peripheral.delegate = self
    }
    
    deinit {
        discoveredCharacteristics.removeAll()
    }
    
    func connect() {
        DispatchQueue.main.async {
            self.manager.connect(self)
        }
    }
    
    func disconnect() {
        guard manager.state.value == .poweredOn else {
            return
        }        
        
        manager.cancelPeripheralConnection(self)
    }
    
    func addRssiReading(_ rssiReading: Double) {
        rssiReadings.append(rssiReading)
    }
    
    func discoverServices(deviceServicesIdentifiers: [String]) {
        serviceScanUUIDs = deviceServicesIdentifiers.map({ CBUUID(string: $0) })
        
        discoveredServices.removeAll()
        discoveredCharacteristics.removeAll()
        
        peripheral.discoverServices(serviceScanUUIDs)
    }
    
    func characteristic(for characteristicString: String) -> BluetoothCharacteristic? {
        guard peripheral.state == .connected else {
            return nil
        }
        
        for characteristic in discoveredCharacteristics {
            if characteristic.uuid == CBUUID(string: characteristicString.uppercased()) {
                return characteristic
            }
        }
        
        return nil
    }
    
    @discardableResult
    func readValue(for characteristicString: String) -> Bool {
        guard peripheral.state == .connected else {
            return false
        }
        
        for characteristic in discoveredCharacteristics {
            if characteristic.uuid == CBUUID(string: characteristicString.uppercased()) {
                characteristic.readValueForCharacteristic()
                return true
            }
        }
        
        return false
    }
    
    func readRSSI() {
        guard peripheral.state == .connected else {
            return
        }
        
        peripheral.readRSSI()
    }
    
    // MARK: - helpers
    
    private func containsAllDiscoveredServices() -> Bool {
        guard let serviceScanUUIDs = serviceScanUUIDs else {
            return false
        }
        
        let containsAll = serviceScanUUIDs.containsAll(items: self.discoveredServices)
        return containsAll
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        
        self.discoveredServices.append(service.uuid)
        
        service.characteristics?.forEach({ (characteristic) in
            self.discoveredCharacteristics.append(characteristic)
        })
        
        // Check if all characteristics are discovered
        let containsAll = self.containsAllDiscoveredServices()
        if containsAll {
            DispatchQueue.main.async {
                self.delegate?.onFinishedScanningForCharacteristcs(sucess: containsAll)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        
        if let btCharacteristic = self.characteristic(for: characteristic.uuid.uuidString) {
            DispatchQueue.main.async {
                self.delegate?.onUpdateValue(characteristic: btCharacteristic, data: characteristic.value)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        
        if let btCharacteristic = self.characteristic(for: characteristic.uuid.uuidString) {
            DispatchQueue.main.async {
                self.delegate?.onWriteValue(characteristic: btCharacteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        
        if let btCharacteristic = self.characteristic(for: characteristic.uuid.uuidString) {
            DispatchQueue.main.async {
                self.delegate?.onUpdateNotificationState(characteristic: btCharacteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            assertionFailure(error.localizedDescription)
            return
        }
        
        DispatchQueue.main.async {
            self.rssiReadings.append(RSSI.doubleValue)
        }
    }
}
