//
//  CompetifitApp.swift
//  Competifit
//
//  Created by Naman Talreja on 27/06/24.
//

import SwiftUI
import SwiftData
import Firebase
@main
struct CompetifitApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
