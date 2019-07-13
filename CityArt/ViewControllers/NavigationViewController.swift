//
//  NavigationViewController.swift
//  CityArt
//
//  Created by Colin Smith on 7/12/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NavigationViewController: UIViewController {

    @IBOutlet weak var navigationMapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    var currentCoordinate = CLLocationCoordinate2D()
    
    var streetArt: StreetArt?
    
    private let chicago: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.874338, longitude: -87.647154)
    private let chicagoArea: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.874338, longitude:  -87.647154), latitudinalMeters: 70000, longitudinalMeters: 70000)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        navigationMapView.setRegion(chicagoArea, animated: true)
    }
    var stepsToDestination: [MKRoute.Step] = []
    
    
    
    //You might get an error here due to the map having MKAnnotations not MKMapItems
    func getDirections(to destination: MKMapItem){
        let source = MKPlacemark(coordinate: currentCoordinate)
        let sourceMapItem = MKMapItem(placemark: source)
        
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { (response, error) in
            if let error = error {
                print("There was an error calculating the directions to destination /n --------- /n")
                print(error)
                print("/n -------- /n")
                print(error.localizedDescription)
            }
            guard let response = response else {return}
            let primaryRoute = response.routes[0]
            
            self.navigationMapView.addOverlay(primaryRoute.polyline)
            
            self.stepsToDestination = primaryRoute.steps
            
            
        }
        
        
    }
    
    
    
}// End of Class


extension NavigationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.first else {return}
        currentCoordinate = currentLocation.coordinate
        navigationMapView.userTrackingMode = .followWithHeading
        
    }
}


extension NavigationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 12
            return renderer
        }
        return MKPolylineRenderer()
    }
}

