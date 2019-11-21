//
//  ViewController.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, HomeServiceDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var userLocation: CLLocation? = nil
    private var service: HomeService!
    private var places = [Place]()
    
    private let locationManager = CLLocationManager()
    private let logoNavigationBarName = "logo_navbar"
    private let annotationIdentifier = "AnnotationIdentifier"
    private let cellIdentifier = "cell"
    private let pinImage = UIImage(named: "map_marker")
    private let detailsIdentifier = "detailsSegue"
    private let favoritesIdentifier = "favoritesSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let logo = UIImage(named: logoNavigationBarName)
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        
        service = HomeService(delegate: self)
        
        settingLocationManager()
        
        tableViewHeightConstraint.constant = 0
        tableView.tableFooterView = UIView(frame: .zero)

    }
    
    //MARK: location's methods
    func settingLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(userLocation == nil) {
            userLocation = locations[0] as CLLocation
            if let location = userLocation {
                service.getOpenPlaces(from: "\(location.coordinate.latitude),\( location.coordinate.longitude)")
                centerMapOnLocation(location: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    //MARK: Service's'methods
    func getOpenPlacesSuccessful(_ places: [Place]) {
        self.places = places
        places.forEach { (place) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            mapView.addAnnotation(annotation)
        }
        
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    func getOpenPlacesFailed(_ data: Data?) {
        
        let alert = UIAlertController(title: "Error", message: "Something went wrong. You may be able to try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: TableView's methods
    func updateTableViewHeight() {
        if(places.count > 0) {
            tableViewHeightConstraint.constant = view.frame.height * 0.40
        }
        updateViewConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PlaceTableViewCell

        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        
        let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
        cell.distanceLabel.text = userLocation?.myDistance(coordinate: location)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailsIdentifier, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: Actions
    @IBAction func favoritesTouchUpInside(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: favoritesIdentifier, sender: self)
    }
    
    
    //MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == detailsIdentifier) {
            let indexPath = sender as! IndexPath
            let place = places[indexPath.row]
            let viewController = segue.destination as! PlaceDetailsViewViewController
            viewController.id = place.id
        } else if(segue.identifier == favoritesIdentifier) {
            let viewController = segue.destination as! FavoritesViewController
            viewController.userLocation = userLocation
        }
    }
}

extension CLLocation {
    
    func myDistance(coordinate: CLLocation) -> String{
        
        let distanceInMeters = distance(from: coordinate)
        
        if distanceInMeters < 1000 {
            return String(format: "%.0f", distanceInMeters) + " M away"
        } else {
            let distanceInKilometer = distanceInMeters /  1000
            return String(format:"%.1f", distanceInKilometer) + " KM away"
        }
    }
    
}



