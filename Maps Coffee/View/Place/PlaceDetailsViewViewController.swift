//
//  PlaceDetailsViewViewController.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import UIKit
import MapKit


class PlaceDetailsViewViewController: UIViewController, PlaceServiceDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var id = ""
    private var service: PlaceService!
    
    private let favoriteImage = "heart_filled"
    private let webSiteIdentifier = "webViewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service = PlaceService(delegate: self)
        service.getDetails(from: id)
        
        if (Favorite.getByID(id) == nil) {
            updateImageColor(isFavorite: false)
        } else {
            updateImageColor(isFavorite: true)
        }
    }
    
    //MARK: Layout's methods
    func updateImageColor(isFavorite: Bool) {
        let originalImage = UIImage(named: favoriteImage);
        let changedImage = originalImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        favoriteButton.setImage(changedImage, for: .normal)
        if(isFavorite) {
            favoriteButton.tintColor = UIColor.init(red: 224/255, green: 11/255, blue: 29/255, alpha: 1)
        } else {
            favoriteButton.tintColor = UIColor.gray
        }
    }

    //MARK: Service's methods
    func getDetailsPlaceSuccessful(_ place: Place) {
        navigationItem.title = place.name
        addressLabel.text = place.address
        centerMapOnLocation(place: place)
    }
    
    func getDetailsPlaceFailed(_ data: Data?) {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. You may be able to try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //Mark: Location's methods
    func centerMapOnLocation(place: Place) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: Actions
    @IBAction func favoriteTouchUpInside(_ sender: UIButton) {
        if (Favorite.getByID(id) == nil) {
            if let place = Place.getByID(id) {
                let favorite = Favorite()
                favorite.id = place.id
                favorite.name = place.name
                favorite.latitude = place.latitude
                favorite.longitude = place.longitude
                Favorite.save(favorite)
                updateImageColor(isFavorite: true)
            }
        } else if let favorite = Favorite.getByID(id) {
            Favorite.deleteObject(favorite)
            updateImageColor(isFavorite: false)
        }
    }
    
    @IBAction func openWebsiteTouchUpInside(_ sender: UIButton) {
        performSegue(withIdentifier: webSiteIdentifier, sender: nil)
    }
    
    @IBAction func callTouchUpInside(_ sender: UIBarButtonItem) {
    
        if  let place = Place.getByID(id) {
            var number = place.phoneNumber.replacingOccurrences(of: "(", with: "")
            number = number.replacingOccurrences(of: ")", with: "")
            number = number.replacingOccurrences(of: " ", with: "")
            number = number.replacingOccurrences(of: "-", with: ""  )
            if let url = URL(string: "telprompt://\(number)"),
            UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            }
        }
    }
    
    //MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == webSiteIdentifier) {
            let viewController = segue.destination as! PlaceSiteViewController
            viewController.id = id
        }
    }
}
