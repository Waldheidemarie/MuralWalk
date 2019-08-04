//
//  Mural.swift
//  CityArt
//
//  Created by Colin Smith on 6/19/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import CloudKit

//MARK: - User Object

class User {
    var username: String
    var email: String
    
    let recordID: CKRecord.ID
    let appleUserReference: CKRecord.Reference
    
    init(username: String, email: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString) , appleUserReference: CKRecord.Reference){
        self.username = username
        self.email = email
        self.recordID = recordID
        self.appleUserReference = appleUserReference
    }
}

extension User {
    convenience init?(record: CKRecord) {
        guard let username = record[UserConstants.usernameKey] as? String,
            let email = record[UserConstants.emailKey] as? String,
            let appleUserReference = record[UserConstants.appleUserReferenceKey] as? CKRecord.Reference else {return nil}
        self.init(username: username, email: email, recordID: record.recordID, appleUserReference: appleUserReference)
    }
}


extension CKRecord {
    convenience init(user: User){
        self.init(recordType: UserConstants.typeKey, recordID: user.recordID)
        self.setValue(user.username, forKey: UserConstants.usernameKey)
        self.setValue(user.email, forKey: UserConstants.emailKey)
        self.setValue(user.appleUserReference, forKey: UserConstants.appleUserReferenceKey)
    }
}


struct UserConstants {
    static let typeKey = "User"
    fileprivate static let usernameKey = "Username"
    fileprivate static let emailKey = "Email"
    fileprivate static let appleUserReferenceKey = "AppleUserReferenceKey"
}



//MARK: - StreetArt Object

class StreetArt: NSObject, Codable, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let lat = self.latitude,
            let long = self.longitude else {return CLLocationCoordinate2D()}
        return CLLocationCoordinate2D(latitude: lat.degreeValue, longitude: long.degreeValue)
    }
    let muralID: String
    let artist: String?
    let latitude: String?
    let longitude: String?
    let title: String?
    var subtitle: String? {
        return self.artist
    }
    let fundingSource: String?
    let yearInstalled: String?
    let yearRestored: String?
    let streetAddress: String?
    let locationDescription: String?
    let artworkDescription: String?

    enum CodingKeys: String, CodingKey {
        case muralID = "mural_registration_id"
        case artist = "artist_credit"
        case latitude = "latitude"
        case longitude = "longitude"
        case title = "artwork_title"
        case fundingSource = "affiliated_or_commissioning"
        case yearInstalled = "year_installed"
        case yearRestored = "year_restored"
        case streetAddress = "street_address"
        case locationDescription = "location_description"
        case artworkDescription = "description_of_artwork"
        
    }
}

//MARK: - Mural Object
class Mural {
    let muralID: String
    let recordID: CKRecord.ID
    var hasComment: Bool

    init(muralID: String){
        self.muralID = muralID
        self.recordID = CKRecord.ID(recordName: UUID().uuidString)
        self.hasComment = false

    }
    //Failable Init?
    init?(cloudkitRecord: CKRecord) {
        guard let muralID = cloudkitRecord[MuralConstants.muralIDKey] as? String,
              let hasComment = cloudkitRecord[MuralConstants.hasCommentKey] as? Bool
            else { return nil }
        self.muralID = muralID
        self.recordID = cloudkitRecord.recordID
        self.hasComment = hasComment
        
    }
}

//MARK: - Mural Extension
//extension Mural {
//    convenience init?(cloudKitRecord: CKRecord){
//        guard let muralID = cloudKitRecord[MuralConstants.muralIDKey] as? String
//            else {return nil}
//    
//    self.init(cloudKitRecord: cloudKitRecord)
//    }
//}

//MARK: - CKRecord Extension


extension CKRecord {
    convenience init(tour: Tour){
        self.init(recordType: TourConstants.typeKey, recordID: tour.recordID)
        self.setValue(tour.muralIDs, forKey: TourConstants.muralIDsKey)
        self.setValue(tour.userReference, forKey: TourConstants.userReferenceKey)
    }
}

extension CKRecord {
    convenience init(mural: Mural){
        self.init(recordType: MuralConstants.typeKey, recordID: mural.recordID)
        self.setValue(mural.muralID, forKey: MuralConstants.muralIDKey)
        self.setValue(mural.hasComment, forKey: MuralConstants.hasCommentKey)
        
    }
}


extension CKRecord {
    convenience init(comment: Comment){
        self.init(recordType: CommentConstants.typeKey, recordID: comment.recordID)
        self.setValue(comment.muralReference, forKey: CommentConstants.muralReferenceKey)
        self.setValue(comment.text, forKey: CommentConstants.textKey)
        self.setValue(comment.timeStamp, forKey: CommentConstants.timeStampKey)
    }
}

//MARK: - Tour Object
class Tour: Equatable{

    var title : String
    let recordID: CKRecord.ID
    var userReference: CKRecord.Reference
    let muralIDs: [String]
    var description: String
    var length: Double = 0.0
    var streetArtwork: [StreetArt]
    
    init(title: String, description: String, userReference: CKRecord.Reference, length: Double, streetArtwork: [StreetArt] = [], muralIDs: [String] = []){
        self.title = title
        self.recordID = CKRecord.ID(recordName: UUID().uuidString)
        self.userReference = userReference
        self.muralIDs = muralIDs
        self.description = description
        self.length = length
        self.streetArtwork = streetArtwork
    }
    init?(cloudkitRecord: CKRecord) {
        guard let muralIDs = cloudkitRecord[TourConstants.muralIDsKey] as? [String],
            let userReference = cloudkitRecord[TourConstants.userReferenceKey] as? CKRecord.Reference
            else { return nil }
        self.muralIDs = muralIDs
        self.userReference = userReference

    }
    
    static func == (lhs: Tour, rhs: Tour) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

//extension Tour {
//    convenience init?(cloudkitRecord: CKRecord){
//        guard let muralIDs = cloudkitRecord[TourConstants.muralIDsKey] as? [String],
//            let userReference = cloudkitRecord[TourConstants.userReferenceKey] as? CKRecord.Reference
//            else {return nil}
//
//        self.init(muralIDs: muralIDs, userReference: userReference)
//    }
//}

//MARK: - Comment Object
class Comment{
    var text: String
    var timeStamp: Date = Date()
    var muralReference: CKRecord.Reference
    var recordID: CKRecord.ID
    
    init(text: String, timestamp: Date = Date(), muralReference: CKRecord.Reference){
        self.text = text
        self.timeStamp = timestamp
        self.muralReference = muralReference
        self.recordID = CKRecord.ID(recordName: UUID().uuidString)
    }
}



extension Comment {
    convenience init?(cloudkitRecord: CKRecord){
        guard let text = cloudkitRecord[CommentConstants.textKey] as? String,
            let timestamp = cloudkitRecord[CommentConstants.timeStampKey] as? Date,
            let muralReference = cloudkitRecord[CommentConstants.muralReferenceKey] as? CKRecord.Reference
            //let recordID = cloudkitRecord[CommentConstants.recordKey] as? CKRecord.ID
            else {return nil}
        
        self.init(text: text, timestamp: timestamp, muralReference: muralReference)
    }
}



//MARK: - Constants
struct CommentConstants {
    static let typeKey = "Comment"
    static let textKey = "Text"
    static let timeStampKey = "Timestamp"
    static let muralReferenceKey = "MuralReference"
    static let recordKey = "RecordID"
}

struct MuralConstants {
    static let typeKey = "Mural"
    static let tourReferenceKey = "TourReference"
    static let muralIDKey = "MuralRegistrationID"
    static let artistKey = "Artist"
    static let latitudeKey = "Latitude"
    static let longitudeKey = "Longitude"
    static let titleKey = "Title"
    static let fundingSourceKey = "FundingSource"
    static let yearInstalledKey = "YearInstalled"
    static let yearRestoredKey = "YearRestored"
    static let streetAddressKey = "StreetAddress"
    static let locationDescriptionKey = "LocationDescription"
    static let artworkDescriptionKey = "ArtworkDescription"
    static let commentsKey = "Comments"
    static let hasCommentKey = "HasComment"
}

struct TourConstants {
    static let typeKey = "Tour"
    static let titleKey = "Title"
    static let recordKey = "RecordID"
    static let userReferenceKey = "UserReference"
    static let muralIDsKey = "MuralIDs"
    static let descriptionKey = "Description"
    static let distanceKey = "Distance"
    
}
