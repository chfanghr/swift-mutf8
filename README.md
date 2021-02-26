# Swift MUTF-8 [![CI](https://github.com/chfanghr/swift-mutf8/actions/workflows/CI.yml/badge.svg)](https://github.com/chfanghr/swift-mutf8/actions/workflows/CI.yml)

This library is for those who want to write their own JVM in swift.<br>
It contains mutf-8 string encoding/decoding facilities.

## Usage

* Use `MUTF-8.encode(utf8:)`  to convert a utf8 encoding uint8 array to mutf8 encoding
* Use `MUTF-8.decode(mutf8:)` to convert a mutf8 encoding uint8 array back to utf8 encoding

## Adding MUTF8 as a Dependency

Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/chfanghr/swift-mutf8", from: "1.0.0"),
```

Then, include `MUTF8` as a dependency for your executable target:

```swift
.product(name: "MUTF8", package: "swift-mutf8"),
```

## Known issue(s)

* Doesn't work correctly when decodes a string which originally contains emoji 

## TODO

- [ ] Fix emoji
- [ ] Unit tests 
