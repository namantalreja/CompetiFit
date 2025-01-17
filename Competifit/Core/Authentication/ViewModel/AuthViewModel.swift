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
    @Published var currentGroupID: String?
    @Published var currentGroup: UserGroup?

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
    
    func getGroupsSteps() async -> [[Step]]{
        var groupsSteps: [[Step]] = []
        
        do {
            guard let currGroupID = currentUser?.groupID else {return []}
            guard let snapshot = try? await Firestore.firestore().collection("groups").document(currGroupID).getDocument() else { return [] }
            var currUserGroup = try snapshot.data(as: UserGroup.self)
            for groupMember in currUserGroup.members {
                guard let memberData = try? await Firestore.firestore().collection("users").document(groupMember).getDocument() else {return groupsSteps}
                var temp = try memberData.data(as: User.self)
                groupsSteps.append(temp.weeklySteps)
            }
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        return groupsSteps
    }
    
    
    func getGroupMembers() async -> [User] {
        var groupMembers: [User] = []
        do {
//            guard let currGroupID = currentUser?.groupID else {return []}
            guard let snapshot = try? await Firestore.firestore().collection("groups").document(currentGroupID!).getDocument() else { return [] }
            var currUserGroup = try snapshot.data(as: UserGroup.self)
            for groupMember in currUserGroup.members {
                guard let memberData = try? await Firestore.firestore().collection("users").document(groupMember).getDocument() else {return []}
                var temp = try memberData.data(as: User.self)
                print("User: \(temp)")
                groupMembers.append(temp)
            }
            return groupMembers
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        return groupMembers
    }

    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            var hm = HealthManager()
            try await hm.calculateSteps()
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, groupID: "none", weeklySteps: hm.steps)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func createGroup(code: String, groupName: String) async throws {
        do {
            guard let currentUserSession = currentUser else {
                print("Current user does not exist")
                return
            }
            var group = UserGroup(entryId: code, members: currentUser != nil ? [currentUser!.id] : [], groupName: groupName, id: UUID())
            try Firestore.firestore().collection("groups").document("\(group.id)").setData(from: group)
            
            let ref = Firestore.firestore().collection("users").document(currentUserSession.id)
            try await ref.updateData([
                "groupID": "\(group.id)"
              ])
            currentGroupID = group.id.uuidString
        } catch let error {
          print("Error writing city to Firestore: \(error)")
        }
    }
    
    func joinGroup(code: String) async throws -> Bool {
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
                        "members": FieldValue.arrayUnion([currentUserSession.id])
                       ]) { error in
                           if let error = error {
                               print("Error adding user to the group: \(error.localizedDescription)")
                               
                           }
                           else {
                               print("User successfully added to the group")
                               self.currentGroupID = groupID                        
                               Firestore.firestore().collection("users").document(currentUserSession.id).updateData([
                                   "groupID": groupID
                               ])
                               
                               { error in
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
        self.currentGroupID = currentUser?.groupID
        if currentGroupID != "none" {
            guard let snapshot = try? await Firestore.firestore().collection("groups").document(currentGroupID!).getDocument() else { return }
            self.currentGroup = try? snapshot.data(as: UserGroup.self)
        }
        
        
        print("Current user:\(self.currentUser)")
    }

}

