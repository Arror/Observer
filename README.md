# Observer

### Sample

```swift
struct Person {
    
    var name: String = "Name0"
}

let op = Observer(Person())
        
op.observe(keyPath: \.name) { op, old, new in
            
    print("Name ==> Old: \(old) -- New: \(new)")
}

op[\.name] = "Name1"
op[\.name] = "Name2"
op[\.name] = "Name3"

// Output
// 
// Name ==> Old: Name0 -- New: Name1
// Name ==> Old: Name1 -- New: Name2
// Name ==> Old: Name2 -- New: Name3
```