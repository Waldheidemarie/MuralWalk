//
//  MainScreenViewController.swift
//  CityArt
//
//  Created by Colin Smith on 6/19/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainScreenViewController: UIViewController {
    
    var locations: [CLLocation] = []
    var selectedAnnotation: MKAnnotation?
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private let chicago: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.874338, longitude: -87.647154)
    private let chicagoArea: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.874338, longitude:  -87.647154), latitudinalMeters: 70000, longitudinalMeters: 70000)
    
    
    @IBOutlet weak var muralMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muralMapView.delegate = self
        NetworkClient.shared.fetchMurals { (murals) in
            NetworkClient.shared.murals = murals
            self.getLocations()
        }
        self.muralMapView.setCenter(chicago, animated: false)
        self.muralMapView.setRegion(chicagoArea, animated: true)
    }
    
    func getLocations(){
       let muralArray = NetworkClient.shared.murals
        let locationArray = muralArray.map { (mural) -> CLLocation in
            guard let lat = mural.latitude?.degreeValue,
                let long = mural.longitude?.degreeValue else {return CLLocation()}
             self.locations.append(CLLocation(latitude: lat, longitude: long))
            return CLLocation(latitude: lat, longitude: long)
        }
        self.locations = locationArray
        muralMapView.addAnnotations(NetworkClient.shared.murals)
        
        
    }
    
    func configureLocationServices(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status  == . notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func showAnnotationDetail(){
        performSegue(withIdentifier: "toDetailVC"){
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? MuralDetailViewController else {return}
            destinationVC.mural = selectedAnnotation as? Mural
            
        }
    }


}// End of ViewController Class

//MARK: - Extensions
extension MainScreenViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Mural else {return nil}
        self.selectedAnnotation = annotation
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let button = UIButton(type: .contactAdd)
            view.rightCalloutAccessoryView = button
            button.addTarget(self, action: #selector(showAnnotationDetail), for: .touchUpInside)
            view.selectedGlyphImage = UIImage(named: "paint")
            view.markerTintColor = UIColor(hue: 226/360, saturation: 0.62, brightness: 0.77, alpha: 1.0)
         
        }
        return view
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got Latest Loc")
        guard let latestLocation = locations.first else {return}
        currentCoordinate = latestLocation.coordinate
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status Changed")
    }
    
}
extension String {
    var degreeValue: CLLocationDegrees {
        return (self as NSString).doubleValue
    }
}
