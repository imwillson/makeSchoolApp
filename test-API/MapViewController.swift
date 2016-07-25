//
//  MapViewController.swift
//  test-API
//
//  Created by Willson Li on 7/15/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

import Foundation

import UIKit

class MapViewController: UIViewController { // this class is a uiviewcontroller
    

    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from 
        
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
                                                          longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "United States of America"
        marker.map = mapView
        
        
        //locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()

    }

}



