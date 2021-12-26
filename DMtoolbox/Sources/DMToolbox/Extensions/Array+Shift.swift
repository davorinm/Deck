import Foundation

extension Array {
    func shiftArray(_ amount: Int = 1) -> [Element] {
        if amount > 0 {
            // Shift right
            
            let shifts = amount % self.count
            return Array(self[shifts ..< count] + self[0 ..< shifts])
        
        } else {
            // Shift left
            
            let shifts = amount % self.count
            return Array(self[shifts ..< count] + self[0 ..< shifts]).reversed()
        }
    }
    
    mutating func shift(_ amount: Int = 1) {
        self = shiftArray(amount)
    }
}
