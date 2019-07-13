//
//  UserController.swift
//  CityArt
//
//  Created by Colin Smith on 7/12/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CloudKit 

class UserController {
    
    static let shared = UserController()
    var currentUser: User?
    
    func createUserWith(username: String, email: String, completion: @escaping (User?) -> Void) {
        var appleUserReference: CKRecord.Reference?
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let refrence = reference else {completion(nil) ; return}
            
            guard let foundUserReference = appleUserReference else { completion(nil) ; return}
            let newUser = User(username: username, email: email, appleUserReference: foundUserReference)
            let privateDB = CKContainer.default().privateCloudDatabase
            let userRecord = CKRecord(user: newUser)
            
            CloudKitController.shared.save(record: userRecord, database: privateDB) { (record) in
                guard let record = record else {completion(nil) ; return}
                let user = User(record: record)
                self.currentUser = user
            }
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        var appleUserReference: CKRecord.Reference?
        guard let foundUserReference = appleUserReference else { completion(false) ; return}
        let database = CloudKitController.shared.privateDB
        let predicate = NSPredicate(format: "appleUserReference == %@", foundUserReference)
        CloudKitController.shared.fetchSingleRecord(ofType: UserConstants.typeKey, with: predicate, database: database) { (records) in
            guard let records = records,
                let record = records.first
                else {completion(false); return}
            
            self.currentUser = User(record: record)
            completion(true)
        }
        
    }
    
}
