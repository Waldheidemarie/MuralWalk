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


class Mural: NSObject, Codable, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let lat = self.latitude,
              let long = self.longitude else {return CLLocationCoordinate2D()}
        return CLLocationCoordinate2D(latitude: lat.degreeValue, longitude: long.degreeValue)
    }

    
    
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
    var comments: [Comment] = []
    var visits: Int = 0
    
    enum CodingKeys: String, CodingKey {
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


struct Tour: Equatable{

    var title : String
    var description: String
    let identifier: String
    var murals: [Mural]?
    var comments: [Comment]
    
    static func == (lhs: Tour, rhs: Tour) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct Comment {
    var text: String
}
