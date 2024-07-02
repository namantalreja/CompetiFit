//
//  LeaderboardsView.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct LeaderboardsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var inputtedCode: String = ""
    @State var currGroupID: String? = nil
    @State var members: [User] = []
    
    
    var body: some View {
        NavigationStack {
            if currGroupID == nil || currGroupID == "none" {
                VStack {
                    Button("Create Group!") {
                        async {
                            try await currGroupID = viewModel.createGroup(code: UserGroup.randomString(length: 6))
                        }
                    }
                    InputView(text: $inputtedCode,
                              title: "Enter Joining Code",
                              placeholder: "Enter Joining Code")
                        .autocapitalization(.none)
                    
                    Button("Join Group") {
                        async {
                            try await viewModel.joinGroup(code: inputtedCode)
                            currGroupID = inputtedCode

                        }
                    }
                }
                
            } else {
                ScrollView {
                    GroupsComponent(code: currGroupID == nil ? "" : currGroupID!)
                }
                .padding()
                .navigationTitle("Your Groups")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }.onAppear {
            currGroupID = viewModel.currentUser?.groupID
        }
        
        
    }
}

#Preview {
    LeaderboardsView()
}
