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
        if let user = viewModel.currentUser {
            
            NavigationStack {
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
                        
                        
                        NavigationLink{
                            CreateGroupScreen()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                           Text("Join Group")
                        }
                        
                        
                        
                        
                    }
                }
            }
            
            
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
                .environmentObject(AuthViewModel())
        }
    }
}
