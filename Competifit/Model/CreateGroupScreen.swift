//
//  CreateGroupScreen.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/28/24.
//

import SwiftUI

struct CreateGroupScreen: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var healthManager: HealthManager
    @State var userGroupID = "none"
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    async{
                        do{
                            try await self.userGroupID = viewModel.createGroup(code: GroupID(entryId: UserGroup.randomString(length: 6)))
                        }
                    }
                } label: {
                    Text("Create Group")
                }
                
                Text("\(userGroupID)")
                
                Button {
                    async{
                        do{
                            try await viewModel.joinGroup(groupID: userGroupID)
                        }
                    }
                } label: {
                    Text("Join Group")
                }
            }
        }
        
    }
}

#Preview {
    CreateGroupScreen()
}
