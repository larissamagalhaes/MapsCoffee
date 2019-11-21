//
//  FavoritesViewController.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import UIKit
import CoreLocation

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var data: [Favorite] = []
    var userLocation: CLLocation? = nil
    
    private let cellIdentifier = "cell"
    private let detailsIdentifier = "detailsSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favorites = Favorite.all() {
            data = favorites
        }

        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: TableView's methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (data.count == 0) {
            let noResultLabel = UILabel(frame: tableView.bounds)
            noResultLabel.textColor = UIColor(white: 60.0/255.0, alpha: 1)
            noResultLabel.numberOfLines = 0
            noResultLabel.textAlignment = NSTextAlignment.center
            noResultLabel.font = noResultLabel.font.withSize(14)
            noResultLabel.text = "You haven't added any place to your favorites"
            noResultLabel.sizeToFit()
            
            tableView.backgroundView = noResultLabel
        } else {
            tableView.backgroundView = nil
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FavoriteTableViewCell
        
        let favorite = data[indexPath.row]
        cell.nameLabel.text = favorite.name
        
        let location = CLLocation(latitude: favorite.latitude, longitude: favorite.longitude)
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
    
    //MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == detailsIdentifier) {
            let indexPath = sender as! IndexPath
            let favorite = data[indexPath.row]
            let viewController = segue.destination as! PlaceDetailsViewViewController
            viewController.id = favorite.id
        }
    }
}
