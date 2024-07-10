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
    @StateObject var healthManager = HealthManager()
    
    init(){
        FirebaseApp.configure()
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().backgroundColor = UIColor(red: 0.9254901960784314, green: 0.35294117647058826, blue: 0.35294117647058826, alpha: 1)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(healthManager)
        }
    }
}
