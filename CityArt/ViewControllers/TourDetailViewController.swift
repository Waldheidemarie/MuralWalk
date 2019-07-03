//
//  TourDetailViewController.swift
//  CityArt
//
//  Created by Colin Smith on 7/1/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import MapKit
class TourDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var muralListTableView: UITableView!
    @IBOutlet weak var tourMapView: MKMapView!
    
    
    private let chicago: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.874338, longitude: -87.647154)
    private let chicagoArea: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.874338, longitude:  -87.647154), latitudinalMeters: 70000, longitudinalMeters: 70000)
    
    var locations: [CLLocation] = []
  //  var coordinates: [CLLocationCoordinate2D] = []
    var tour: Tour? {
        didSet{
            loadViewIfNeeded()
            updateViews()
           
        }
    }
    var selectedAnnotation: MKAnnotation?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tourMapView.delegate = self
        muralListTableView.delegate = self
        muralListTableView.dataSource = self
        titleTextField.text = tour?.title
        if tour?.description != nil {
            descriptionTextView.text = tour?.description
        }else {
            descriptionTextView.text = ""
        }
         plotMurals()
        self.tourMapView.setCenter(chicago, animated: false)
        self.tourMapView.setRegion(chicagoArea, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        getDirections()
    }
    
    @objc func showAnnotationDetail(){
        performSegue(withIdentifier: "toDetailVC"){
            
        }
    }
    
    func updateViews(){
        titleTextField.text = tour?.title
        if tour?.description != nil {
            descriptionTextView.text = tour?.description
        }else {
            descriptionTextView.text = ""
        }
//        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//        tourMapView.addOverlay(polyline)
        
    }
    //MARK: - MapView Functions
    func plotMurals(){
        guard let tour = tour else {return}
        let muralArray = tour.murals
        let locationArray = muralArray.map { (mural) -> CLLocation in
            guard let lat = mural.latitude?.degreeValue,
                let long = mural.longitude?.degreeValue else {return CLLocation()}
            self.locations.append(CLLocation(latitude: lat, longitude: long))
            return CLLocation(latitude: lat, longitude: long)
        }
        self.locations = locationArray
        tourMapView.addAnnotations(tour.murals)
        
//        let coordinates = muralArray.map { (mural) -> CLLocationCoordinate2D in
//            guard let lat = mural.latitude?.degreeValue,
//                let long = mural.longitude?.degreeValue else {return CLLocationCoordinate2D()}
//            self.coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
//             return CLLocationCoordinate2D(latitude: lat, longitude: long)
//        }
        
    }

    func getDirections(){
        let request = createDirectionsRequest()
        let directions = MKDirections(request: request)
        directions.calculate {(response, error) in
            if let error = error {
                print(error)
            }
            guard let response = response else {return}
            self.tourMapView.addOverlay(response.routes[0].polyline)
            self.tourMapView.setVisibleMapRect(response.routes[0].polyline.boundingMapRect, animated: false)
        }
    }
    func createDirectionsRequest() -> MKDirections.Request{
        
        guard let tour = tour else {return MKDirections.Request()}
        guard let last = tour.murals.last?.coordinate,
              let first = tour.murals.first?.coordinate else {return MKDirections.Request()}
        //FIXME: - This only supports first and last waypoints in the mural array
        
        let destination = MKPlacemark(coordinate: last)
        let source = MKPlacemark(coordinate: first)
        let request =  MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        return request
        
    }
    //MARK: TableView DataSource
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tour = tour else {return 0}
       return tour.murals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "muralListCell", for: indexPath)
        guard let tour = tour else {return UITableViewCell()}
        cell.textLabel?.text = tour.murals[indexPath.row].title
        return cell
    }
}

//MARK: - MapView Delegate Methods

extension TourDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
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
            view.markerTintColor = UIColor(hue: 226/360, saturation: 0.62, brightness: 0.77, alpha: 1.0)
            
        }
        return view
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as? MuralDetailViewController
            guard let chosenCell = self.muralListTableView.indexPathForSelectedRow else {return}
            guard let tour = tour else {return}
            let chosenMural = tour.murals[chosenCell.row]
            destinationVC?.mural = chosenMural
        }
    }
}




