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
            if viewModel.userSession != nil {
                ProfileView()
                    .environmentObject(viewModel)
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
