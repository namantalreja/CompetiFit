//
//  Step.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/27/24.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}