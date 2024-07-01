//
//  GroupsComponent.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/30/24.
//

import SwiftUI

struct GroupsComponent: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationLink {
            InidividualGroupView()
        } label: {
            HStack {
                Text("Group 1 Name")
                    .foregroundStyle(.white)
                
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(.cyan)
            .cornerRadius(10.0)
        }
    }
}

#Preview {
    GroupsComponent()
}
