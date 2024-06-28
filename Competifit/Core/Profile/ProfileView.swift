//
//  ProfileView.swift
//  Competifit
//
//  Created by Naman Talreja on 27/06/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var healthManager = HealthManager()
    var body: some View {
        if let user = viewModel.currentUser{
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Sign Out",
                                        tintColor: .red)
                    }

                    Button {
                        print("Delete account..")
                        async {
                            do {
                                try await healthManager.calculateSteps()
                                print("\(healthManager.steps)")
                            } catch {
                                print("Doesnt work")
                            }
                        }
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: .red)
                    }
                    
                    Button {
                        async {
                            do {
                                try await viewModel.createGroup()
                            } catch {
                                print("Error")
                            }
                        }
                    } label: {
                        Text("Create Group")
                    }
                    
                    Button {
                        async {
                            do {
                                try await viewModel.joinGroup(groupID: "F956F09F-F178-4B72-A654-BD966E17E0B8")
                            } catch {
                                print("Error")
                            }
                        }
                    } label: {
                        Text("Create Group")
                    }
                }
                
                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
