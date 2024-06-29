//
//  GroupID.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/28/24.
//

import Foundation

class GroupID: Identifiable, Codable {
    let entryId: String
    var groupUIUD: String = ""
    var id = UUID()
    
    init(entryId: String) {
        self.entryId = entryId
    }

}
