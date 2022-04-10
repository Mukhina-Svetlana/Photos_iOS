//
//  Base.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import Foundation
import UIKit

class Base {
    
    let userDefaults = UserDefaults.standard
    private let keyId = "UseDefault"
    static let shared = Base()
    
    struct ArrayUsers: Codable {
        var name: String
        var password: String
        var image: Data
    }
    
    var users: [ArrayUsers] {
        get {
            if let data = userDefaults.value(forKey: keyId) as? Data {
                return try! PropertyListDecoder().decode([ArrayUsers].self, from: data)
            } else {
                return [ArrayUsers]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                userDefaults.set(data, forKey: keyId)
            }
        }
    }
    
    func saveUser(name: String, password: String, image: UIImage) {
        let user = ArrayUsers(name: name, password: password, image: image.pngData()!)
        users.append(user)
    }
}
