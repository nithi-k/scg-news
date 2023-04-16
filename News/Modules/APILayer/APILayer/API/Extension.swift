//
//  Extension.swift
//  APILayer
//
//  Created by Nithi Kulasiriswatdi on 11/5/2564 BE.

import Networking
import RxSwift

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

extension Dictionary {
    func toData() -> Data? {
        if !JSONSerialization.isValidJSONObject(self) {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        return data
    }
}

public extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }

    var thaiPhoneFormatPadding: String {
        return self.leftPadding(toLength: 10, withPad: "0")
    }
}
