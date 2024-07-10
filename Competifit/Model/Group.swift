//
//  Group.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/27/24.
//

import Foundation

struct UserGroup: Identifiable, Codable {
    let entryId: String
    var members: [String]
    var groupName: String
    var id = UUID()
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
    
    
    
}
