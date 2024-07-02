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
    
    
    var body: some View {
        ScrollView {
            ForEach (groupMembers) { member in
                RankComponent(name: member.fullname, steps: member.weeklySteps)
            }
        }
        .padding()
        .onAppear {
            async{
                self.groupMembers = try await viewModel.getGroupMembers()
                print(groupMembers)
                //try await print(viewModel.getGroupsSteps())
            }
        }
    }
}

#Preview {
    InidividualGroupView()
}
