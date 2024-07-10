//
//  ContentView.swift
//  Competifit
//
//  Created by Naman Talreja on 27/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var healthManager: HealthManager
    var body: some View {
        Group {
            if viewModel.currentUser != nil {
                TabView {
                    LeaderboardsView()
                        .environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "shared.with.you")
                            Text("Leaderboards")
                        }
                    ProfileView()
                        .environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                                .font(Font.custom(Fonts.ARCADE_BODY, size: 12))
                        }
                }
                .onAppear {
                    async {
                        try await self.healthManager.requestAuthorization()
                    }
                }
                .accentColor(Color(red: 1, green: 0.9294117647058824, blue: 0.5098039215686274))
                
            } else{
                
                LoginView()
            }
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
