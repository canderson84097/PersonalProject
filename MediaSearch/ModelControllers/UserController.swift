//
//  UserController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/26/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    // Source Of Truth for User Favorites
    static var favorites: [MediaItem] = []
    
    var currentUser: User?
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    
    func createUser(with username: String, completion: @escaping (Bool) -> Void) {
        fetchAppleUsername { (reference) in
            guard let reference = reference else { completion(false); return }
            let newUser = User(username: username, appleUserRef: reference)
            let record = CKRecord(user: newUser)
            self.publicDB.save(record) { (record, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                    completion(false)
                    return
                }
                guard let record = record,
                let savedUser = User(ckRecord: record)
                else { completion(false); return }
                
                self.currentUser = savedUser
                print("Created user \(record.recordID.recordName) successfully")
                completion(true)
            }
        }
    }
    
    func fetchUser(userName: String, completion: @escaping (Bool) -> Void) {
        fetchAppleUsername { (reference) in
            guard let reference = reference else { completion(false); return }
            
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserConstants.appleUserRefKey, reference])
            let predicate2 = NSPredicate(format: "%K == %@", argumentArray: [UserConstants.usernameKey, userName])
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
            let query = CKQuery(recordType: UserConstants.recordTypeKey, predicate: compoundPredicate)
            self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                    completion(false)
                    return
                }
                
                guard let record = records?.first,
                    let foundUser = User(ckRecord: record)
                    else { completion(false); return }
                
                self.currentUser = foundUser
                print("Fetched User: \(record.recordID.recordName) successfully")
                completion(true)
            }
        }
    }
    
    func fetchAppleUsername(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let recordID = recordID else { completion(nil); return }
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(reference)
        }
    }
}
