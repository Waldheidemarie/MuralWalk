//
//  TourController.swift
//  CityArt
//
//  Created by Colin Smith on 6/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

class TourController {
    
    static let shared = TourController()
    
    var tours: [Tour] = []
    
    //CRUD Functions
    func newTour(title: String){
        let newTour = Tour(title: title, description: "", identifier: UUID().uuidString, length: 0.0, murals: [], comments: [])
        self.tours.append(newTour)
    }
        func addToTour(tour: inout Tour, mural: Mural){
            tour.murals.append(mural)
    }
    
    func deleteTour(tour: Tour){
        
    }
    //MARK: Custom Instance Methods
    
   
}
