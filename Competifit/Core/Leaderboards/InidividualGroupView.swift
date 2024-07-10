//
//  InidividualGroupView.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct InidividualGroupView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var groupMembers: [User] = []
    var groupID: String?
    var joinCode: String
    
    var groupName: String = ""
    
    init(groupID: String?, joinCode: String) {
        self.groupID = groupID
        self.joinCode = joinCode
    }
    
    
    var body: some View {
        
        VStack {
            Text("Leaderboards")
                .font(Font.custom(Fonts.ARCADE_TITLE, size: 26))
            
            ScrollView {
                ForEach (groupMembers) { member in
                    RankComponent(name: member.fullname, steps: member.weeklySteps)
                }
            }
            .padding()
            .onAppear {
                Task {
                    self.groupMembers = try await viewModel.getGroupMembers()
                }
            }
            
            HStack{
                Text("Join Code: \(joinCode)")
                    .font(Font.custom(Fonts.ARCADE_BODY, size: 26))
            }
        }
        
    }
}

#Preview {
    InidividualGroupView(groupID: "", joinCode: "LOL")
}
