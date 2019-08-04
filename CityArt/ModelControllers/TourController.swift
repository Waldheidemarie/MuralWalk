//
//  TourController.swift
//  CityArt
//
//  Created by Colin Smith on 6/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CloudKit

class TourController {
    
    static let shared = TourController()
    
    var tours: [Tour] = []
    
    //CRUD Functions
    func newTour(user: User, title: String){
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
        let newTour = Tour(title: title, description: "", userReference: userReference,  length: 0.0, streetArtwork: [])
        self.tours.append(newTour)
    }
        func addToTour(tour: inout Tour, mural: StreetArt){
            tour.streetArtwork.append(mural)
    }
    
    func deleteTour(tour: Tour){
        
    }
    //MARK: - Cloudkit Methods
    
    
    
   
}
