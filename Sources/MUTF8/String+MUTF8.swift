//
//  String+MUTF8.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation

public extension StringProtocol {
    var bytes: [UInt8] { .init(utf8) }

    var mutf8: [UInt8] {
        (try? MUTF8.encode(utf8: bytes)) ?? []
    }
}

public extension String {
    init?(mutf8Data data: [UInt8]) {
        self.init(bytes: (try? MUTF8.decode(mutf8: data)) ?? [], encoding: .utf8)
    }
}
