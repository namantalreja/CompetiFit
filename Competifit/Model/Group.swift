//
//  Group.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/27/24.
//

import Foundation

struct UserGroup: Identifiable, Codable {
    
    var member: [User]
    var id = UUID()
    
    init(user: User) {
        member = [user]
        
    }
    
    
    
    
    
    
}
