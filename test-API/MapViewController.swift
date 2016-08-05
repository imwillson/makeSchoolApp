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
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManagerSession = CLLocationManager()
    
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
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                self.addressLabel.unlock()
                // 3
                let lines = address.lines as [String]!
                self.addressLabel.text = lines.joinWithSeparator("\n")
                
                // 4
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,
                                                    bottom: labelHeight, right: 0)
                
                
            }
        }
    }


}

extension MapViewController: CLLocationManagerDelegate {
  
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
     
        if status == .AuthorizedWhenInUse {
            locationManagerSession.startUpdatingLocation()
          
            self.mapView.myLocationEnabled = true
            self.mapView.settings.myLocationButton = true }
    }
  
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
         
            locationManagerSession.stopUpdatingLocation() }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        addressLabel.lock()
    }
}

