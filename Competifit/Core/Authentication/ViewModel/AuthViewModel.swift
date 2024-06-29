//
//  AuthViewModel.swift
//  Competifit
//
//  Created by Naman Talreja on 27/06/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init() {
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }

    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }

    }

    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, groupID: "none")
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func createGroup(code: GroupID) async throws -> String {
        do {
            guard let currentUserSession = currentUser else {
                print("Current user does not exist")
                return""
            }
            var group = UserGroup(user: currentUserSession)
            code.groupUIUD = group.id.uuidString
            try Firestore.firestore().collection("groups").document("\(group.id)").setData(from: group)
            try Firestore.firestore().collection("codes").document(code.entryId).setData(from: code)
            
            let ref = Firestore.firestore().collection("users").document(currentUserSession.id)
            try await ref.updateData([
                "groupID": "\(group.id)"
              ])
            return code.entryId
        } catch let error {
          print("Error writing city to Firestore: \(error)")
        }
        return ""
    }
    
    func joinGroup(groupID: String) async throws {
        do {
            guard let currentUserSession = currentUser else {
                print("Current user does not exist")
                return
            }
            var group = UserGroup(user: currentUserSession)
            guard let snapshot = try? await Firestore.firestore().collection("groups").document(groupID).getDocument() else { return }
            var groupFirebase = try? snapshot.data(as: UserGroup.self)
            groupFirebase?.member.append(currentUserSession)
            try Firestore.firestore().collection("groups").document(groupID).setData(from: groupFirebase)
            
            let ref = Firestore.firestore().collection("users").document(currentUserSession.id)
            try await ref.updateData([
                "groupID": "\(groupID)"
              ])
        } catch let error {
          print("Error writing city to Firestore: \(error)")
        }
    }
    

    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    func deleteAccount() {
    }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("Current user:\(self.currentUser)")
    }
}

