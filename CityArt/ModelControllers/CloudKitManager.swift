//
//  CloudKitManager.swift
//  CityArt
//
//  Created by Colin Smith on 7/6/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func saveRecordToCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void){
        database.save(record) { (_, error) in
            if let error = error {
                print("Error Saving record to cloudkit \(#function),  \(error.localizedDescription) /n---/n \(error)")
            }
        }
        completion(true)
    }
    
    
    func modify(records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?){
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) in
            completion?(records, error)
        }
        
        publicDB.add(operation)
        
    }
}
