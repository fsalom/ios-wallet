//
//  UserDefaultsManager.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 7/12/23.
//

import Foundation

class UserDefaultsManager: CacheManagerProtocol {
    func save<T: Codable>(objectFor: String, this data: T) {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            print("🤬 ERROR: Cache.save(objectFor: \(objectFor)) > JSON ENCODER ERROR")
            return
        }
        UserDefaults.standard.set(encodedData, forKey: objectFor)
    }

    func retrieve<T: Decodable>(objectFor: String, of type: T.Type) -> T? {
        guard let savedData = UserDefaults.standard.object(forKey: objectFor) as? Data  else { return nil }
        guard let object = try? JSONDecoder().decode(T.self, from: savedData) else { return nil }
        return object
    }

    func set(_ String: String, _ value: Any?) {
        UserDefaults.standard.set(value, forKey: String)
    }

    func get(stringFor: String) -> String? {
        return UserDefaults.standard.string(forKey: stringFor)
    }

    func get(intFor: String) -> Int {
        return UserDefaults.standard.integer(forKey: intFor)
    }

    func get(doubleFor: String) -> Double {
        return UserDefaults.standard.double(forKey: doubleFor)
    }

    func get(floatFor: String) -> Float {
        return UserDefaults.standard.float(forKey: floatFor)
    }

    func get(boolFor: String) -> Bool {
        return UserDefaults.standard.bool(forKey: boolFor)
    }

    func get(arrayFor: String) -> [Any]? {
        return UserDefaults.standard.array(forKey: arrayFor)
    }

    func get(anyFor: String) -> Any? {
        return UserDefaults.standard.object(forKey: anyFor) as Any
    }

    func get(dictionaryArrayFor: String) -> [String: [Any]]? {
        return UserDefaults.standard.dictionary(forKey: dictionaryArrayFor) as? [String: [Any]]
    }

    func get(dictionaryFor: String) -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: dictionaryFor)
    }

    func clear() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

