import Vapor

extension Application {
    var foo: Foo {
        if let existing = self.storage[Foo.FooKey.self] {
            return existing
        } else {
            let new = Foo()
            self.storage[Foo.FooKey.self] = new
            return new
        }
    }
}

class Foo {
    fileprivate struct FooKey: StorageKey {
        typealias Value = Foo
    }
    
    var bar: Int = 0
    
    
}
