//
//  User.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/18/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit
import CloudKit

class User {
    var username: String
    var password: String
    var favorite: [MediaItem] = []
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    var photoData: Data?
    var profileImage: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoAsset: CKAsset? {
        get {
            guard photoData != nil else { return nil }
            let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(".jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print(error.localizedDescription)
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init (username: String, password: String, favorite: [MediaItem] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference, profileImage: UIImage? = nil) {
        
        self.username = username
        self.password = password
        self.favorite = favorite
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.profileImage = profileImage
    }
}

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserConstants.usernameKey] as? String,
            let password = ckRecord[UserConstants.passwordKey] as? String,
            let appleUserRef = ckRecord[UserConstants.appleUserRefKey] as? CKRecord.Reference
            else { return nil }
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[UserConstants.photoAssetKey] as? CKAsset {
            do {
                if let fileURL = photoAsset.fileURL {
                    let data = try Data(contentsOf: fileURL)
                    foundPhoto = UIImage(data: data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        self.init(username: username, password: password, recordID: ckRecord.recordID, appleUserRef: appleUserRef, profileImage: foundPhoto)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    convenience init (user: User) {
        self.init(recordType: UserConstants.recordTypeKey, recordID: user.recordID)
        self.setValuesForKeys([
            UserConstants.usernameKey : user.username,
            UserConstants.passwordKey : user.password,
            UserConstants.appleUserRefKey : user.appleUserRef
        ])
        
        if user.photoAsset != nil {
            self.setValue(user.photoAsset, forKey: UserConstants.photoAssetKey)
        }
    }
}

struct UserConstants {
    static let recordTypeKey = "User"
    static let usernameKey = "username"
    static let passwordKey = "password"
    static let appleUserRefKey = "appleUserRef"
    static let photoAssetKey = "photoAsset"
}
