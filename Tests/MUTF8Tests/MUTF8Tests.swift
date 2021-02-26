//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/26.
//

@testable import MUTF8
import XCTest

final class MUTF8Tests: XCTestCase {
    func testDecodeOneByteCharacter() throws {
        let encoded: [UInt8] = [0x41]
        let decoded = try MUTF8.decode(mutf8: encoded)
        let decodedString = String(bytes: decoded, encoding: .utf8)
        XCTAssertNotNil(decodedString)
        XCTAssertEqual(decodedString!, "A")
    }

    func testDecodeTwoByteCharacter() throws {
        let encoded: [UInt8] = [0xC2, 0xA9]
        let decoded = try MUTF8.decode(mutf8: encoded)
        let decodedString = String(bytes: decoded, encoding: .utf8)
        XCTAssertNotNil(decodedString)
        XCTAssertEqual(decodedString!, "©")
    }

    func testDecodeThreeByteCharacter() throws {
        let encoded: [UInt8] = [0xE3, 0x81, 0x82]
        let decoded = try MUTF8.decode(mutf8: encoded)
        let decodedString = String(bytes: decoded, encoding: .utf8)
        XCTAssertNotNil(decodedString)
        XCTAssertEqual(decodedString!, "あ")
    }

    func testDecodeSupplementaryCharacter() throws {
        let encoded: [UInt8] = [0xED, 0xA1, 0x80, 0xED, 0xB4, 0x94]
        let decoded = try MUTF8.decode(mutf8: encoded)
        let decodedString = String(bytes: decoded, encoding: .utf8)
        XCTAssertNil(decodedString)
    }

    func testDecodeNullCharacter() throws {
        let encoded: [UInt8] = [0xC0, 0x80]
        let decoded = try MUTF8.decode(mutf8: encoded)
        let decodedString = String(bytes: decoded, encoding: .utf8)
        XCTAssertNotNil(decodedString)
        XCTAssertEqual(decodedString!, "\u{0000}")
    }

    func testDecodeString() throws {
        let encoded: [UInt8] = [
            0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0xE4, 0xB8,
            0x96, 0xE7, 0x95, 0x8C, 0x21, 0x20, 0x53, 0x61,
            0x6E, 0x74, 0xC3, 0xA9, 0xED, 0xA0, 0xBC, 0xED,
            0xBD, 0xBB,
        ]
        let decoded = try MUTF8.decode(mutf8: encoded)
        let decodedString = String(decoding: decoded, as: UTF8.self)
        XCTAssertNotNil(decodedString)
        // TODO: - Fix emoji
    }
    
    func testEncode() throws{
        let expected = "Hello \u{0000}World".bytes
        let coded = try MUTF8.encode(utf8: "Hello \0World".bytes)
        let decoded = try MUTF8.decode(mutf8: coded)
        XCTAssertEqual(expected, decoded)
    }
}
