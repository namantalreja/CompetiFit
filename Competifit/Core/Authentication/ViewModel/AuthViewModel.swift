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
    
    func createGroup(code: String) async throws -> String {
        do {
            guard let currentUserSession = currentUser else {
                print("Current user does not exist")
                return""
            }
            var group = UserGroup(entryId: code, member: currentUser != nil ? [currentUser!.id] : [], id: UUID())
            try Firestore.firestore().collection("groups").document("\(group.id)").setData(from: group)
            
            let ref = Firestore.firestore().collection("users").document(currentUserSession.id)
            try await ref.updateData([
                "groupID": "\(group.id)"
              ])
            return code
        } catch let error {
          print("Error writing city to Firestore: \(error)")
        }
        return ""
    }
    
    func joinGroup(code: String) async throws -> Bool{
        guard let currentUserSession = currentUser else {
               print("Current user does not exist")
               return false
           }
           var groupID: String = ""
           do {
               let snapshot = try await Firestore.firestore().collection("groups")
                   .whereField("entryId", isEqualTo: String(code))
                   .getDocuments()

               if snapshot.documents.isEmpty || snapshot.documents.count > 1 {
                   print(snapshot.documents)
                   print("No groups or too many groups found")
                   return false
               }
               if let documentData = snapshot.documents.first?.data() {
                   if let groupUUID = documentData["id"] as? String {
                       groupID = groupUUID
                   } else {
                       print("Group UUID not found")
                       return false
                   }
               } else {
                   print("Document data not found")
                   return false
               }
           } catch {
               print("Error querying Firestore: \(error.localizedDescription)")
               return false
           }
           if !groupID.isEmpty {
               print("Group UUID: \(groupID)")
               do {
                      try await Firestore.firestore().collection("groups").document(groupID).updateData([
                        "member": FieldValue.arrayUnion([currentUserSession.id])
                       ]) { error in
                           if let error = error {
                               print("Error adding user to the group: \(error.localizedDescription)")
                               
                           }
                           else {
                               print("User successfully added to the group")
                        
                               Firestore.firestore().collection("users").document(currentUserSession.id).updateData([
                                   "groupID": groupID
                               ]) { error in
                                   if let error = error {
                                       print("Error updating user's groupID: \(error.localizedDescription)")
                                   } else {
                                       print("User's groupID successfully updated")
                                   }
                               }
                           }
                       }
                   return true
                   }
           }
        return true
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

