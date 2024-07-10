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
    @State var groupName: String = ""
    @State var currGroupID: String? = nil
    @State var members: [User] = []
    var toBeJoinCode = UserGroup.randomString(length: 6)
    
    
    var body: some View {
  
            ZStack {
                Color(red: 0.8901960784313725, green: 0.8117647058823529, blue: 0.6666666666666666)
                    .ignoresSafeArea()
            if viewModel.currentGroupID == nil || viewModel.currentGroupID == "none" {
                VStack {
                    Spacer()
                    VStack {
                        Text("Create Your Group!")
                            .font(Font.custom(Fonts.ARCADE_TITLE, size: 20))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        TextField("Enter group name", text: $groupName)
                            .foregroundColor(.black)
                            .font(Font.custom(Fonts.ARCADE_BODY, size: 18))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button {
                            if groupName != "" {
                                async {
                                    try await viewModel.createGroup(code: toBeJoinCode, groupName: groupName)
                                }
                            }
                        } label: {
                            Text("CREATE")
                                .padding(5)
                                .font(Font.custom(Fonts.ARCADE_BODY, size: 15))
                                .background(Color(red: 0.9411764705882353, green: 0.8117647058823529, blue: 0.8117647058823529))
                                .foregroundColor(.black)
                        }
                        .cornerRadius(7)
                        .padding(.bottom)
                            
                    }
                    .background(Color(red: 0.5254901960784314, green: 0.8666666666666667, blue: 0.803921568627451))
                    .cornerRadius(10.0)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding()
                    
                    
                    VStack {
                        Text("Join Group!")
                            .font(Font.custom(Fonts.ARCADE_TITLE, size: 20))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        TextField("Enter group code", text: $inputtedCode)
                            .foregroundColor(.black)
                            .font(Font.custom(Fonts.ARCADE_BODY, size: 18))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button {
                            async{
                                try await viewModel.joinGroup(code: inputtedCode)
                            }
                            
                        } label: {
                            Text("JOIN")
                                .padding(5)
                                .font(Font.custom(Fonts.ARCADE_BODY, size: 15))
                                .background(Color(red: 0.5254901960784314, green: 0.8666666666666667, blue: 0.803921568627451))
                                .foregroundColor(.black)
                        }
                        .cornerRadius(7)
                        .disabled(inputtedCode == "")
                        .padding(.bottom)
                            
                    }
                    .background(Color(red: 0.9411764705882353, green: 0.8117647058823529, blue: 0.8117647058823529))
                    .cornerRadius(10.0)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding()
                    
                    Spacer()
                    
                }
            } else {
                InidividualGroupView(groupID: viewModel.currentGroupID, joinCode: toBeJoinCode == "" ? inputtedCode : toBeJoinCode)
            }

                
        
            }
            }
}

#Preview {
    LeaderboardsView()
}
