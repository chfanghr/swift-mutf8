//
//  Error.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation

public extension MUTF8 {
    @frozen
    enum Error: Swift.Error {
        public enum Mode {
            case encoding
            case decoding
        }

        public enum Expected {
            case twoByte
            case threeByte
            case fourByte
            case sixByte
        }

        public enum Position {
            case two
            case three
            case four
            case five
            case six
        }

        case endOfInput(Mode, Expected, Position)
        case invalidUTF8
    }
}
