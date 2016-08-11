
//
//  GoogleMapsHelper.swift
//  test-API
//
//  Created by Willson Li on 7/25/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

import Foundation
import SwiftyJSON

//testß

class GoogleMapsHelper {

    static func getCoordinatesAPI(addressLinkInURL: String, callback: (Double,Double) -> Void) {
        
        let headers =
        [
                "cache-control": "no-cache adslkf"
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
    
   /*
    static func binarySearch(origin: (Double, Double), destination: (Double, Double)) {
        
        midpointOfOriginalRoute =
        
        var newSteps = GMSPath()
        
        var x = newSteps.fromEncodedPath("asdfa")
        
    }
 */
    
    static func convertStepsArrayToWalkingSpeed(array: [Steps]) -> [Steps] {
        var array = array
        let averageWalkingSpeed = 4828.03 // 3 miles -> meters
        let secondsInHour = 3600.00
        let secondsInMinute = 60
      
        
        for steps in 0..<array.count {
            let newTimesInSeconds = Int(round(Double(array[steps].distanceTillNextCoordinate) * (secondsInHour/averageWalkingSpeed)))
            array[steps].durationTillNextCoordinate = newTimesInSeconds
        }
        
        return array
    }
    
    static func addSummationTimeToArray(array: [Steps]) -> [Steps] {
        var summationTracker = 0
        var array = array
        for steps in 0..<array.count {
            array[steps].summationTime = summationTracker + array[steps].durationTillNextCoordinate
            summationTracker = array[steps].summationTime
        }
        
        return array
    }
    
    static func subtractBothSummationTimes(originArray: [Steps], destArray: [Steps]) -> (Double,Double) {
        let randomlyHighNumber: Int = Int.max
        var tempMinCoordinateSteps: Steps?
        var tempMinDurationDifference: Int = randomlyHighNumber
        var absValueArrayOfTimes: [Int] = []
        var summationTimeNegOrPos: Int = 0
        
        for (origin, dest) in zip(originArray, destArray) {
            var timeDifference = (origin.summationTime - dest.summationTime)
            //     absValueArrayOfTimes.append(absValue)
            var absTimeDifference = abs(timeDifference)
            absValueArrayOfTimes.append(absTimeDifference)
            
            if timeDifference < tempMinDurationDifference {
                tempMinDurationDifference = timeDifference
                tempMinCoordinateSteps = dest
                summationTimeNegOrPos = timeDifference

            }
        }
        
        let desiredCoordinate = (tempMinCoordinateSteps!.coordinateLat, tempMinCoordinateSteps!.coordinateLng)
        
        return desiredCoordinate
    }
    


    // travel_mode= driving or walking
    static func getDistanceMatrix(address1: String, address2: String, travel_mode travelMode: String, callback: (GMSPath, (Double, Double)) -> Void) { //you can simply this to tuples

        //origins=41.43206,-81.38992|-33.86748,151.20699
        
        let headers = ["cache-control": "no-cache"]
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(address1)&destination=\(address2)&mode=\(travelMode)&departure_time=now&avoid=highways&traffic_model=best_guess&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")
        
       
        
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
                
                let encodedPolyline = json["routes"][0]["overview_polyline"]["points"].stringValue
                print("encodedPolyline: ", encodedPolyline)
                let polylineHalfMap = GMSPath(fromEncodedPath: encodedPolyline)
                
                //callback(polylineHalfMap!)
                
                
                
                
                /*
                 
                
                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                routePolyline = GMSPolyline(path: path)
                routePolyline.map = mapView
                
                
                var bounds = GMSCoordinateBounds()
                
                for index in 1...path.count() {
                    bounds = bounds.includingCoordinate(path.coordinateAtIndex(index))
                }
                
                mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds))
                
                */
                
                
                //callback(json["routes"][0]["overview_polyline"].stringValue)
                
                let stepsJSON = json["routes"][0]["legs"][0]["steps"]

                //print(json)
                
                //example for array
//                let status = json["status"].stringValue
//                print(status)

                var arrayOfStepsFromOrigin: [Steps] = []
                
                for keys in stepsJSON {
                    var newStep = Steps(json: keys.1) //BREAK THROUGH
                    
                    
                    arrayOfStepsFromOrigin.append(newStep)
                }
                
                ///var tempArray: [Steps] = arrayOf
                ///print("first coorindate of origin array", arrayOfStepsFromOrigin[0].coordinateLat)
                ///print("fifth coordinate of origin array", arrayOfStepsFromOrigin[4].coordinateLat)
                
                //this is where I reverse the array
                //arrayOfStepsFromDestination = arrayOfStepsFromOrigin.map { ($0.copy()) }
                
                var arrayOfStepsFromDestination: [Steps] = []
                
                for i in arrayOfStepsFromOrigin.reverse() {
                        arrayOfStepsFromDestination.append(i)
                }
                
                
                let averageWalkingSpeed = 4828.03 // 3 miles -> meters
                let secondsInHour = 3600.00
                let secondsInMinute = 60

                
                // the duration for the wakling array is now converted
                print("duration till next coordinate CONVERTED")
                // everytime you parse through the array, i turns into a copy.
                
                
                arrayOfStepsFromDestination = convertStepsArrayToWalkingSpeed(arrayOfStepsFromDestination)
                arrayOfStepsFromDestination = addSummationTimeToArray(arrayOfStepsFromDestination)
                arrayOfStepsFromOrigin = addSummationTimeToArray(arrayOfStepsFromOrigin)
                
                let desiredCoordinate = subtractBothSummationTimes(arrayOfStepsFromOrigin,destArray: arrayOfStepsFromDestination)
                print(desiredCoordinate)
                
                callback((polylineHalfMap!), desiredCoordinate)

                
//                
//                if summationTimeNegOrPos > 0 {
//                    //origin = the coordinate
//                }
                
//                else if summationTimeNegOrPos < 0 {
//                    // destination = the coordinate
//                }
                
            }
          
    
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



