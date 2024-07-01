//
//  LeaderboardsView.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct LeaderboardsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach (0..<10) { number in
                    GroupsComponent()
                }
            }
            .padding()
            .navigationTitle("Your Groups")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
}

#Preview {
    LeaderboardsView()
}
