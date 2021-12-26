import Foundation

extension Array {
    /*
     Randomly shuffles the array in-place
     This is the Fisher-Yates algorithm, also known as the Knuth shuffle.
     Time complexity: O(n)
     */
    public mutating func shuffle() {
        for i in 0..<count {
            let j = arc4random_uniform(UInt32(i))
            if i != j {
                self.swapAt(i, Array.Index(j))
            }
        }
    }
}

