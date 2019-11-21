//
//  PlaceSiteViewController.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import UIKit
import WebKit

class PlaceSiteViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let place = Place.getByID(id) {
            navigationItem.title = place.name
            if let url = URL(string: place.site) {
                let request = URLRequest(url: url)
                webView.load(request as URLRequest)
            }
        }
    }
}
