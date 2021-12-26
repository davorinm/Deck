import Foundation
import CoreBluetooth

protocol BluetoothCharacteristic {
    var uuid: CBUUID { get }
    var serviceUUID: CBUUID? { get }
    var value: Data? { get }
    var isNotifying: Bool { get }
    
    func readValueForCharacteristic()
    func writeValue(_ data: Data, type: CBCharacteristicWriteType)
    func setNotifyValue(_ enabled: Bool)
}

extension CBCharacteristic: BluetoothCharacteristic {
    var serviceUUID: CBUUID? { return self.service?.uuid }
        
    func readValueForCharacteristic() {
        guard self.service?.peripheral?.state == .connected else {
            return
        }
        
        self.service?.peripheral?.readValue(for: self)
    }
    
    func writeValue(_ data: Data, type: CBCharacteristicWriteType) {
        guard self.service?.peripheral?.state == .connected else {
            return
        }
        
        self.service?.peripheral?.writeValue(data, for: self, type: type)
    }
    
    func setNotifyValue(_ enabled: Bool) {
        guard self.service?.peripheral?.state == .connected else {
            return
        }
        
        guard properties.contains(CBCharacteristicProperties.notify) else {
            return
        }
        
        self.service?.peripheral?.setNotifyValue(enabled, for: self)
    }
}
