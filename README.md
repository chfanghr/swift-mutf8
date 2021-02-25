# Swift MUTF-8

This library is for those who want to write their own JVM in swift.<br>
It contains mutf-8 string encoding/decoding facilities.


## Adding MUTF8 as a Dependency

Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/chfanghr/swift-mutf8", from: "1.0.0"),
```

Then, include `MUTF8` as a dependency for your executable target:

```swift
.product(name: "MUTF8", package: "swift-mutf8"),
```

## TODO

- [ ] Unit tests 
