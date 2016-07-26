//
//  GoogleMapsHelper.swift
//  test-API
//
//  Created by Willson Li on 7/25/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

import Foundation
import SwiftyJSON

class GoogleMapsHelper {

    static func getCoordinatesAPI(addressLinkInURL: String, callback: (Double,Double) -> Void) {
        
        let headers =
        [
                "cache-control": "no-cache"
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressLinkInURL)&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        
        let session = NSURLSession.sharedSession() //sharedsession, returns a singleton object, shared has constraints
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil)
            {
                print(error)
            }
            else
            {
                let httpResponse = response as? NSHTTPURLResponse
                //print(httpResponse)
                
                let json = JSON(data: data!)
                
                //print(json)
                
                
                let latLongData = ((json["results"][0]["geometry"]["location"]["lat"].doubleValue), (json["results"][0]["geometry"]["location"]["lng"].doubleValue))
                
                //                self.latitude = latLongData.0
                //                self.longitude = latLongData.1
                //                print("in the class function get coordinatesapi() :", self.latitude, self.longitude)
                
                print(latLongData.0, latLongData.1)
                callback(latLongData.0, latLongData.1)
                
            }
            
        })
        
        dataTask.resume()
        
        
        //print(coordinates)
        //return coordinates
    }

    // travel_mode= driving or walking
    static func getDistanceMatrix(originLat: Double, originLng: Double, destinationLat: Double, destinationLng: Double, travel_mode travelMode: String) { //you can simply this to tuples
        //origins=41.43206,-81.38992|-33.86748,151.20699
        
        let headers =
            [
                "cache-control": "no-cache"
            ]
        
        "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=40.7184243%2C-74.004693&origins=40.717237%2C-74.0014314&transit_mode=driving&departure_time=now&traffic_model=best_guess&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk"
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(originLat)%2C\(originLng)&destinations=\(destinationLat)%2C\(destinationLng)&mode=\(travelMode)&departure_time=now&traffic_model=best_guess&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")
        
        let request = NSMutableURLRequest(URL: url!, cachePolicy: .UseProtocolCachePolicy,timeoutInterval: 10.0)
        
        request.HTTPMethod = "GET"
        
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil)
            {
                print(error)
                //print(request) this displays the status of the request
                //print(data)
                
            }
            else
            {
                //    let httpResponse = response as? NSHTTPURLResponse
                let json = JSON(data: data!) // converts NSData into SON data
                // first data is a parameter, second data is where the data is coming from
                //print(json)
                print("i got hot sauce in my bag")
                print(json)
                print("i woke up like this")
                
            }
            
        })
        dataTask.resume()
        
    }
    

}