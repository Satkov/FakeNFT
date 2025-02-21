//
//  LocalStorage.swift
//  FakeNFT
//
//  Created by Nikolay on 21.02.2025.
//

import Foundation

final class LocalStorage {
    
    static let shared = LocalStorage()
    
    func saveValue(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getValue(key: String) -> Int {
        UserDefaults.standard.integer(forKey: key)
    }
}
