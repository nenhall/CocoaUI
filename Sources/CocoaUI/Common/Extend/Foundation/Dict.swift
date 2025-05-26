//
//  File.swift
//  
//
//  Created by nenhall on 5/20/25.
//

import Foundation

public extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "EncodingError", code: 0, userInfo: nil)
        }
        return dictionary
    }
}
