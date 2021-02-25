//
//  MUTF8.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation

public enum MUTF8 {
    public static func encode(utf8 input: [UInt8]) throws -> [UInt8] {
        if input.isEmpty {
            return []
        }

        func checkAndGetFromInput(at index: Int, expected: Error.Expected, position: Error.Position) throws -> UInt8 {
            if index >= input.count {
                throw Error.endOfInput(.encoding, expected, position)
            }
            return input[index]
        }

        let length = input.count
        var data = [UInt8]()
        var i = 0

        enum Mode {
            case copy
            case noCopy
        }

        var mode = Mode.noCopy

        while i < length {
            let mark = i
            let byte1 = input[i]
            i += 1

            if byte1 & 0x80 == 0 {
                if byte1 == 0 {
                    if mode == .noCopy {
                        mode = .copy
                        let run = input[0 ..< mark]
                        data.append(contentsOf: run)
                    }
                    data.append(0xC0)
                    data.append(0x80)
                } else if mode == .copy {
                    data.append(byte1)
                }
            } else if byte1 & 0xE0 == 0xC0 {
                if mode == .copy {
                    data.append(byte1)
                    let byte2 = try checkAndGetFromInput(at: i, expected: .twoByte, position: .two)
                    i += 1
                    data.append(byte2)
                }
            } else if byte1 & 0xF0 == 0xE0 {
                if mode == .copy {
                    data.append(byte1)
                    let byte2 = try checkAndGetFromInput(at: i, expected: .threeByte, position: .two)
                    i += 1
                    data.append(byte2)
                    let byte3 = try checkAndGetFromInput(at: i, expected: .threeByte, position: .three)
                    i += 1
                    data.append(byte3)
                }
            } else if byte1 & 0xF8 == 0xF0 {
                if mode == .noCopy {
                    mode = .copy
                    let run = input[0 ..< mark]
                    data.append(contentsOf: run)
                }

                let byte2 = try checkAndGetFromInput(at: i, expected: .fourByte, position: .two)
                i += 1
                data.append(byte2)
                let byte3 = try checkAndGetFromInput(at: i, expected: .fourByte, position: .three)
                i += 1
                let byte4 = try checkAndGetFromInput(at: i, expected: .fourByte, position: .four)
                i += 1

                var bits: UInt32 = (UInt32(byte1) & 0x07) << 18
                bits += (UInt32(byte2) & 0x3F) << 12
                bits += (UInt32(byte3) & 0x3F) << 6
                bits += UInt32(byte4) & 0x3F

                data.append(0xED)
                data.append(UInt8(0xA0 + (((bits >> 16) - 1) & 0x0F)))
                data.append(UInt8(0x80 + ((bits >> 10) & 0x3F)))

                data.append(0xED)
                data.append(UInt8(0xB0 + ((bits >> 6) & 0x0F)))
                data.append(byte4)
            }
        }

        if mode == .noCopy {
            return input
        }

        return data
    }

    public static func decode(mutf8 input: [UInt8]) throws -> [UInt8] {
        if input.isEmpty {
            return []
        }

        func checkAndGetFromInput(at index: Int, expected: Error.Expected, position: Error.Position) throws -> UInt8 {
            if index >= input.count {
                throw Error.endOfInput(.decoding, expected, position)
            }
            return input[index]
        }

        let length = input.count
        var data = [UInt8]()
        var i = 0

        enum Mode {
            case copy
            case noCopy
        }

        var mode = Mode.noCopy

        while i < length {
            let mark = i
            let byte1 = input[i]
            i += 1

            if byte1 & 0x80 == 0 {
                if mode == .noCopy {
                    continue
                }
                data.append(byte1)
            } else if byte1 & 0xE0 == 0xC0 {
                let byte2 = try checkAndGetFromInput(at: i, expected: .twoByte, position: .two)
                i += 1

                if byte1 != 0xC0 || byte2 != 0x80 {
                    if mode == .noCopy {
                        continue
                    }
                    data.append(byte1)
                    data.append(byte2)
                } else {
                    if mode == .noCopy {
                        mode = .copy
                        let run = input[0 ..< mark]
                        data.append(contentsOf: run)
                    }
                    data.append(0)
                }
            } else if byte1 & 0xF0 == 0xE0 {
                let byte2 = try checkAndGetFromInput(at: i, expected: .threeByte, position: .two)
                i += 1
                let byte3 = try checkAndGetFromInput(at: i, expected: .threeByte, position: .three)
                i += 1

                if i + 2 < length, byte1 == 0xED, byte2 & 0xF0 == 0xA0 {
                    let byte4 = try checkAndGetFromInput(at: i, expected: .sixByte, position: .four)
                    let byte5 = try checkAndGetFromInput(at: i, expected: .sixByte, position: .five)
                    let byte6 = try checkAndGetFromInput(at: i, expected: .sixByte, position: .six)

                    if byte4 == 0xED, byte5 & 0xF0 == 0xB0 {
                        i += 2

                        var bits: UInt32 = ((UInt32(byte2) & 0x0F) + 1) << 16
                        bits += (UInt32(byte3) & 0x3F) << 10
                        bits += (UInt32(byte5) & 0x0F) << 6
                        bits += UInt32(byte6) & 0x3F

                        if mode == .noCopy {
                            mode = .copy
                            let run = input[0 ..< mark]
                            data.append(contentsOf: run)
                        }

                        data.append(UInt8(0xF0 + ((bits >> 18) & 0x07)))
                        data.append(UInt8(0x80 + ((bits >> 12) & 0x3F)))
                        data.append(UInt8(0x80 + ((bits >> 6) & 0x3F)))
                        data.append(UInt8(0x80 + (bits & 0x3F)))

                        continue
                    }
                }

                if mode == .noCopy {
                    continue
                }

                data.append(byte1)
                data.append(byte2)
                data.append(byte3)
            }
        }

        if mode == .noCopy {
            return input
        }

        return data
    }
}
