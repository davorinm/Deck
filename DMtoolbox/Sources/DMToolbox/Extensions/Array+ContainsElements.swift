import Foundation

extension Array where Element: Equatable {
    func containsAll(items: [Element]) -> Bool {
        guard items.count == self.count else {
            return false
        }
        
        var seen = [Int]()
        var result = true
        for element in items {
            if let elementIndex = self.firstIndex(of: element), elementIndex >= 0 {
                if !seen.contains(elementIndex) {
                    seen.append(elementIndex)
                    result = result && true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        return result
    }
}
