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
    
    // MARK: - Properties
    
    static let shared = UserController()
    var favorites: [MediaItem] = []
    var friends: [User] = []
    var blockedUsers: [User] = []
    var currentUser: User?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    
    func createUser(with username: String, password: String, completion: @escaping (Bool) -> Void) {
        fetchAppleUsername { (reference) in
            guard let reference = reference else { completion(false); return }
            let newUser = User(username: username, password: password, appleUserRef: reference)
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
    
    func fetchUser(userName: String, password: String, completion: @escaping (Bool) -> Void) {
        fetchAppleUsername { (reference) in
            guard let reference = reference else { completion(false); return }
            
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserConstants.appleUserRefKey, reference])
            let predicate2 = NSPredicate(format: "%K == %@", argumentArray: [UserConstants.usernameKey, userName])
            let predicate3 = NSPredicate(format: "%K == %@", argumentArray: [UserConstants.passwordKey, password])
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2, predicate3])
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
    
    // MARK: - Persistence
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let filename = "MediaSearch.json"
        let fullURL = documentDirectory.appendingPathComponent(filename)
        return fullURL
    }
    
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(favorites)
            try data.write(to: fileURL())
        } catch let error {
            print(error)
        }
    }
    
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let favorites = try decoder.decode([MediaItem].self, from: data)
            self.favorites = favorites
        } catch let error {
            print(error)
        }
    }
}
