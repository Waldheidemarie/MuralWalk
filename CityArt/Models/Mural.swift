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

class Mural {
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
    var comments: [Comment]

    

    
    
    init(muralID: String, artist: String?, latitude: String?, longitude: String?, title: String?, fundingSource: String?, yearInstalled: String?, yearRestored: String?, streetAddress: String?, locationDescription: String?, artworkDescription: String?, comments: [Comment] = []){
        self.muralID = muralID
        self.artist = artist
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.fundingSource = fundingSource
        self.yearInstalled = yearInstalled
        self.yearRestored = yearRestored
        self.streetAddress = streetAddress
        self.locationDescription = locationDescription
        self.artworkDescription = artworkDescription
        self.comments = comments

        
    }
    
    
    
    init?(cloudKitRecord: CKRecord){
        guard let muralID = cloudKitRecord[MuralConstants.muralIDKey] as? String,
              let artist = cloudKitRecord[MuralConstants.artistKey] as? String?,
              let latitude = cloudKitRecord[MuralConstants.latitudeKey] as? String?,
              let longitude = cloudKitRecord[MuralConstants.longitudeKey] as? String?,
              let title = cloudKitRecord[MuralConstants.titleKey] as? String?,
              let fundingSource = cloudKitRecord[MuralConstants.fundingSourceKey] as? String?,
              let yearInstalled = cloudKitRecord[MuralConstants.yearInstalledKey] as? String?,
              let yearRestored = cloudKitRecord[MuralConstants.yearRestoredKey] as? String?,
              let streetAddress = cloudKitRecord[MuralConstants.streetAddressKey] as? String?,
              let locationDescription = cloudKitRecord[MuralConstants.locationDescriptionKey] as? String?,
              let artworkDescription = cloudKitRecord[MuralConstants.artworkDescriptionKey] as? String?,
              let comments = cloudKitRecord[MuralConstants.commentsKey] as? [Comment] else {return nil}
        
        self.muralID = muralID
        self.artist = artist
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.fundingSource = fundingSource
        self.yearInstalled = yearInstalled
        self.yearRestored = yearRestored
        self.streetAddress = streetAddress
        self.locationDescription = locationDescription
        self.artworkDescription = artworkDescription
        self.comments = comments
    }
 
    
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: MuralConstants.typeKey)
        record.setValue(muralID, forKey: MuralConstants.muralIDKey)
        return record
    }
}


class Tour: Equatable{

    var title : String
    var description: String
    let identifier: String
    var length: Double = 0.0
    var streetArtwork: [StreetArt]
    var comments: [Comment]
    
    init(title: String, description: String, identifier: String, length: Double, streetArtwork: [StreetArt] = [], comments: [Comment] = []){
        self.title = title
        self.description = description
        self.identifier = identifier
        self.length = length
        self.streetArtwork = streetArtwork
        self.comments = comments
    }
    static func == (lhs: Tour, rhs: Tour) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class Comment{
    var text: String
    var timeStamp: Date = Date()
    
    init(text: String, timestamp: Date = Date()){
        self.text = text
        self.timeStamp = timestamp
    }
}


struct MuralConstants {
    static let typeKey = "Mural"
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
    static let visitsKey = "Visits"
}
