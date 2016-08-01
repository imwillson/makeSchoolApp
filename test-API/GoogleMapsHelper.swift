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

    
    

    static func findTotalDistanceOfPath(path: GMSPath) -> Double {
    
        let numberOfCoords = path.count()
    
        var totalDistance = 0.0
    
        if numberOfCoords > 1 {
        
            var index = 0 as UInt
        
            while index < numberOfCoords - 1 {
            
                //1.1 cal the next distance

                var currentCoord = path.coordinateAtIndex(index)

                var nextCoord = path.coordinateAtIndex(index + 1)

                var newDistance = GMSGeometryDistance(currentCoord, nextCoord)

                totalDistance = totalDistance + newDistance

                index = index + 1

            }
        
        }
        return totalDistance
    
    }
    
    // travel_mode= driving or walking
    static func getDistanceMatrix(address1: String, address2: String, travel_mode travelMode: String) { //you can simply this to tuples
        //origins=41.43206,-81.38992|-33.86748,151.20699
        
        let headers = ["cache-control": "no-cache"]
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(address1)&destination=\(address2)&mode=\(travelMode)&departure_time=now&traffic_model=best_guess&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")
        
        
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
                let stepsJSON = json["routes"][0]["legs"][0]["steps"]

                //print(json)
                
                //example for array
//                let status = json["status"].stringValue
//                print(status)

                var arrayOfStepsFromOrigin: [Steps] = []
                var arrayOfStepsFromDestination: [Steps] = []
                
                for keys in stepsJSON {
                    let newStep = Steps(json: keys.1) //BREAK THROUGH
                    
                    
                    arrayOfStepsFromOrigin.append(newStep)
                }
                
                //var tempArray: [Steps] = arrayOf
                
                //print("first coorindate of origin array", arrayOfStepsFromOrigin[0].coordinateLat)
                //print("fifth coordinate of origin array", arrayOfStepsFromOrigin[4].coordinateLat)
                
                arrayOfStepsFromDestination = arrayOfStepsFromOrigin
                arrayOfStepsFromDestination = arrayOfStepsFromDestination.reverse()
                
                let averageWalkingSpeed = 4828.03
                let secondsInHour = 3600.00
                let secondsInMinute = 60
                
                for i in arrayOfStepsFromDestination {
                    print(i)
                }
                
                for i in arrayOfStepsFromDestination {
                    print(i.durationTillNextCoordinate)
                }
                
                print("\n")
                
                // the duration is now in minutes now!!!
                for i in arrayOfStepsFromDestination {
                    let newTimeInSeconds = Int(Double(i.distanceTillNextCoordinate) * (secondsInHour/averageWalkingSpeed))
                    let newTimeInMinutes = Int(newTimeInSeconds/60)
                    i.durationTillNextCoordinate = newTimeInMinutes
                    print(i.summationTime)
                    
                }
                
               
                
                var summationTracker = 0
                for i in arrayOfStepsFromDestination {
                    i.summationTime = summationTracker + i.durationTillNextCoordinate
                    summationTracker = i.summationTime
                    
                }
                
                //print(arrayOfStepsFromDestination.summationTime)
                
//                var summationTracker = 0
//                for i in arrayOfStepsFromOrigin {
//                    
//                }
//                
                
                
            
                
                
                
                //print("this should be equivalent to the fifth coordinate", arrayOfStepsFromDestination[0].coordinateLat)
                
                
            }
                // first data is a parameter, second data is where the data is coming from
                //print(json)
//                print("JSON REQUEST START")
//                print(json)
//                print("JSON Request END")
                
               
                
                
            
            
        })
        dataTask.resume()
        
    }
    
    static func findMiddlePointInPath(path: GMSPath ,totalDistance distance:Double) -> CLLocationCoordinate2D? {
        
        let numberOfCoords = path.count()
        
        let halfDistance = distance/2
        
        let threadhold = 10 //10 meters
        
        var midDistance = 0.0
        
        if numberOfCoords > 1 {
            
            var index = 0 as UInt
            
            while index  < numberOfCoords{
                
                //1.1 cal the next distance
                
                var currentCoord = path.coordinateAtIndex(index)
                
                var nextCoord = path.coordinateAtIndex(index + 1)
                
                var newDistance = GMSGeometryDistance(currentCoord, nextCoord)
                
                midDistance = midDistance + (newDistance)
                
                print(fabs(midDistance - halfDistance))
                
                if fabs(midDistance - halfDistance) < Double(threadhold) { //Found the middle point in route
                    return nextCoord
                    
                }
                
                
                index = index + 1
                
            }
            
        }
        return nil //Return nil if we cannot find middle point in path for some reason
    }
    

}



/*
 // travel_mode= driving or walking
 static func getDistanceMatrix(originLat: Double, originLng: Double, destinationLat: Double, destinationLng: Double, travel_mode travelMode: String) { //you can simply this to tuples
 //origins=41.43206,-81.38992|-33.86748,151.20699
 
 let headers =
 [
 "cache-control": "no-cache"
 ]
 
 "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=40.7184243%2C-74.004693&origins=40.717237%2C-74.0014314&transit_mode=driving&departure_time=now&traffic_model=best_guess&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk"
 
 let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLat)%2C\(originLng)&destination=\(destinationLat)%2C\(destinationLng)&mode=\(travelMode)&departure_time=now&traffic_model=best_guess&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")
 
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
 print("JSON REQUEST START")
 print(json)
 print("JSON Request END")
 
 
 }
 
 })
 dataTask.resume()
 
 }
 */