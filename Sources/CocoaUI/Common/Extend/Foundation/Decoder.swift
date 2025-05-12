//
//  Decoder.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

import Foundation


public extension JSONDecoder {
    /// 使用示例
    /// do {
    ///     let decoder = JSONDecoder()
    ///     let conversations = try decoder.decode([ConversationData].self, from: jsonData, keyPath: "data")
    ///     print(conversations)
    /// } catch {
    ///     print("解码错误: \(error)")
    /// }
    /// do {
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let json = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested JSON not found for key path \(keyPath)"))
        }
    }
}
