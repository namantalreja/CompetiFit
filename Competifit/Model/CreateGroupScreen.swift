//
//  CreateGroupScreen.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/28/24.
//
import SwiftUI

struct CreateGroupScreen: View {
    @State private var code = ""
    @State private var userGroupID = "none"
    @State private var res = false
    @State private var showingGroupView = false

    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var healthManager: HealthManager

    var body: some View {
        NavigationView {
            VStack {
                Button {
                    Task {
                        do {
                            self.userGroupID = try await viewModel.createGroup(code: UserGroup.randomString(length: 6))
                            showingGroupView = true
                        } catch {
                            print("Error creating group: \(error)")
                        }
                    }
                } label: {
                    Text("Create Group")
                }
                
                Text("Your secret Group ID is \(userGroupID)")
                
                InputView(text: $code,
                          title: "Enter Joining Code",
                          placeholder: "Enter Joining Code")
                    .autocapitalization(.none)
                
                Button {
                    Task {
                        do {
                            res = try await viewModel.joinGroup(code: code)
                            if res {
                                showingGroupView = true
                            } else {
                                print("Join Failed")
                            }
                        } catch {
                            print("Error joining group: \(error)")
                        }
                    }
                } label: {
                    Text("Join Group")
                }
                
                NavigationLink(destination: GroupView(), isActive: $showingGroupView) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
