//
//  ViewController.swift
//  test-API
//
//  Created by Willson Li on 7/13/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import GoogleMaps

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var halfMapView: GMSMapView!
    var coordinateOrigin :(Double,Double)? = (0, 0)
    var coordinateDestination: (Double, Double)? = (0,0)

    @IBOutlet weak var startLocationTextField: UITextField? = nil
    @IBOutlet weak var endLocationTextField: UITextField? = nil


    @IBAction func calculateCoordinate(sender: AnyObject) {
//        guard let x = 0 else  {
//        //show error
//       print("nothing")
//        return
        
        let path = GMSMutablePath()
        path.addLatitude(3.1970044, longitude:101.7389365)
        path.addLatitude(3.2058354, longitude:101.729536)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = halfMapView
//    }
//    
        //let address1 = "1914 71st St, Brooklyn, NY 11204"
//        let address2 = "840 70th Street, Brooklyn, NY 11228"
        
        let address1 = startLocationTextField!.text
        let address2 = endLocationTextField!.text
        //1914 71st St, Brooklyn, NY 11204
        // gmaps link  1914+71st+Street,+Brooklyn,+NY+11204-
        
        let originPoint = AddressToCoordinatesConverter(addressString: address1!)
        let destinationPoint = AddressToCoordinatesConverter(addressString: address2!)
        originPoint.convertAddressToLinkFormat()
        destinationPoint.convertAddressToLinkFormat()
        print(originPoint.addressLink)
        print(destinationPoint.addressLink)
        
        GoogleMapsHelper.getDistanceMatrix(originPoint.addressLink, address2: destinationPoint.addressLink, travel_mode: "driving")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationTextField!.delegate = self
        endLocationTextField!.delegate = self
        
        

        let polylineString = "oyowFtstbMrJzH~JhItEdDlB`BqCbIiEfMOb@Kv@_AfKhEt@lFdAbB\\zFz@pAZpARdB^v@Nj@CRBVBV@n@LpF|Ab@Ab@QV[J[Lo@LSNMl@Sf@Eb@B`@Jl@Tr@d@~@Z|Bl@zCl@xBTx@D|E@fAIh@KRCfEaAnGgBd]mJ`^eRdUwLhKgFpBu@lDsAr@_@zBkA`EmCtAqAf@i@v@s@fCwBtB{AfHoErAy@fB{@jAm@J@n@k@rBgAfDsBzGqD|U_MnAi@pA]d@Kp@EvAGtADvANtA^pAl@hA~@x~@jaAfBtBbJpJpWpX|QpRr@r@FX|AhBn@t@~DhEbFnFv@t@fA`AnAt@nAh@vA^vAHj@?dAKRCtAa@f@Wr@c@RMLQvA}At@kAt@wA\\u@JIFIrAcCdCcFp@mAv@gAj@e@j@a@x@WdAWz@K|@?f@Dv@LR@~LrDrBn@xCn@bANtA\\rHtBf@aAR]t@yA|L{UtOqZhGuLdG}LjOmZlHkNtOoZgMyMr@uA"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
//       

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        
      
    /* taking out code
        //GMSPath(fromEncodedPath: <#T##String#>) FIND OUT WHERE THE M FILE IS!!! WHERE IS THE H FILE??
        
        let pathGeometry = GMSPath(fromEncodedPath: polylineString)
        //print("Test, Reprint Encoded Path: ", pathGeometry)
        
        let totalDistance = GoogleMapsHelper.findTotalDistanceOfPath(pathGeometry!)
        
        //let midpointCoordinates = GoogleMapsHelper.findMiddlePointInPath(pathGeometry!, totalDistance: totalDistance)
        
        print("The Results I need rnTotoal Disiatnace", totalDistance)
        //print("The Results I need again MidPoint Coordinate", midpointCoordinates)
 */
  
        print("")
    }
    
    /// keyboard hiding
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo! // userINfo associated with the NSNotification
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size //CG size contains (width, height) values
        
                                                                        // "UIKeyboardFrameBeingUserINfoKEy" contains CGRectfile
        

        if startLocationTextField!.editing == true {
            
            print("keyboard willhide, self.view.frame.origin.y BEFORE : ", self.view.frame.origin.y)
            
            self.view.frame.origin.y += keyboardSize.height
            print("keyboard willhide, self.view.frame.origin.y AFTER : \n", self.view.frame.origin.y)
         
        }
        
//        if endLocationTextField!.editing == true {
//            self.view.frame.origin.y += keyboardSize.height
//        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        

        if startLocationTextField!.editing == true {
            if keyboardSize.height == offset.height {
                print("offset")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    print("keyboardwillshow, if, selfviewframeoriginY: BEFORE ", self.view.frame.origin.y)
                    self.view.frame.origin.y -= keyboardSize.height
                    print("keyboardwillshow, if, selfviewframeoriginY: AFTER \n", self.view.frame.origin.y)
                    
                
                })
            } else {
                print("not")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    print("keyboardwillshow, else, selfviewframeoriginY: BEFORE ", self.view.frame.origin.y)
                    self.view.frame.origin.y += keyboardSize.height - offset.height
                    print("keyboardwillshow, else, selfviewframeoriginY: AFTER \n", self.view.frame.origin.y)
                    
                })
            }
        }
        
//        if endLocationTextField!.editing == true {
//            if keyboardSize.height == offset.height {
//                print("offset")
//                UIView.animateWithDuration(0.1, animations: { () -> Void in
//                    self.view.frame.origin.y -= keyboardSize.height
//                })
//            } else {
//                print("not")
//                UIView.animateWithDuration(0.1, animations: { () -> Void in
//                    self.view.frame.origin.y += keyboardSize.height - offset.height
//                })
//            }
//        }
    }
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    ///
    
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        startLocationTextField!.resignFirstResponder()
        //endLocationTextField.resignFirstResponder()
    }
    

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


/*
 //callback hell!!!
 GoogleMapsHelper.getCoordinatesAPI(originPoint.addressLink) { (originCoordinates: (Double, Double)) in
 
 
    GoogleMapsHelper.getCoordinatesAPI(destinationPoint.addressLink, callback: { (destinationCoordinates:(Double, Double)) in
 
 //Now we got them two diffent coodinates in heyea
 
         let originLat = originCoordinates.0
         let originLng = originCoordinates.1
         let destinationLat = destinationCoordinates.0
         let destinationLng = destinationCoordinates.1
         
         
         GoogleMapsHelper.getDistanceMatrix(originLat, originLng: originLng, destinationLat: destinationLat, destinationLng: destinationLng, travel_mode: "driving")
 
 
 })
 }
 */

        //print(originPoint.addressLink)

        //dispatch_queue_create("com.appcoda.imagesQueue", DISPATCH_QUEUE_SERIAL)


//        print(coordinateOrigin!.0)
//        print(coordinateOrigin!.1)
//
//        print(coordinateDestination!.0)
//        print(coordinateDestination!.1)
        
//        let headers = [
//            "cache-control": "no-cache",
//            "postman-token": "10fd04bb-3a94-61b2-f425-c78a83690607"
//        ]
//        
//        //origins=41.43206,-81.38992|-33.86748,151.20699
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(self.coordinateOrigin!.0),\(coordinateOrigin!.1)|\(self.coordinateDestination!.0),\(self.coordinateDestination!.1)&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")!,cachePolicy: .UseProtocolCachePolicy,timeoutInterval: 10.0)
//        
//        request.HTTPMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        
//        let session = NSURLSession.sharedSession()
//        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error)
//                //print(request) this displays the status of the request
//                //print(data)
//                
//            } else {
//                let httpResponse = response as? NSHTTPURLResponse
//                let json = JSON(data: data!) // converts NSData into SON data
//                // first data is a parameter, second data is where the data is coming from
//                //print(json)
//                print("i got hot sauce in my bag")
//                print(json)
//                print("i woke up like this")
//            }
//        })
//        
//        dataTask.resume()
//    }
//    
//    







// make it a bad code


// if nil??? do this, if not. do that....










//        print("lol" + String(lol))



/*
 
 dispatch_sync(dispatch_get_global_queue(), {() -> Void in  // IT HITS HERE
 
 originPoint.getCoordinatesAPI { (coordinates) in
 print("///this is the first async///")
 originPoint.latitude = coordinates.0
 originPoint.longitude = coordinates.1
 self.coordinateOrigin = (originPoint.latitude, originPoint.longitude)
 print("///this is the second async, dispatch get main queue")
 self.coordinateOrigin = (originPoint.latitude, originPoint.longitude)
 print(self.coordinateOrigin!.0)
 print(self.coordinateOrigin!.1) //RUNS THIS AFTER IT SENDS BACK TO MAIN QUEUE
 }
 })
 
 
 
 
 
 //dispatch sync is usually done for UI!! Why? Figure it out. specific ui changes
 dispatch_sync(newConcurrentQueue, {() -> Void in  // IT HITS HERE
 
 originPoint.getCoordinatesAPI { (coordinates) in
 print("///this is the first async///")
 originPoint.latitude = coordinates.0
 originPoint.longitude = coordinates.1
 self.coordinateOrigin = (originPoint.latitude, originPoint.longitude)
 print(originPoint.latitude)
 print(originPoint.longitude)
 
 dispatch_sync(dispatch_get_main_queue(), { () -> Void in
 print("///this is the second async, dispatch get main queue")
 self.coordinateOrigin = (originPoint.latitude, originPoint.longitude)
 print(self.coordinateOrigin!.0)
 print(self.coordinateOrigin!.1) //RUNS THIS AFTER IT SENDS BACK TO MAIN QUEUE
 })
 }
 
 })
 
 
 dispatch_sync(newConcurrentQueue, {() -> Void in    // IT HITS HERE
 
 destinationPoint.getCoordinatesAPI { (coordinates) in
 print("///this is the first async///")
 destinationPoint.latitude = coordinates.0
 destinationPoint.longitude = coordinates.1
 self.coordinateDestination = (destinationPoint.latitude, destinationPoint.longitude)
 print(destinationPoint.latitude)
 print(destinationPoint.longitude)
 
 dispatch_sync(dispatch_get_main_queue(), { () -> Void in
 print("///this is the second async, dispatch get main queue")
 self.coordinateDestination = (destinationPoint.latitude, destinationPoint.longitude)
 print(self.coordinateDestination!.0)
 print(self.coordinateDestination!.1) //RUNS THIS AFTER IT SENDS BACK TO MAIN QUEUE
 })
 }
 
 
 })
 
 dispatch_sync(newConcurrentQueue, {() -> Void in
*/


/* taking out code
 //GMSPath(fromEncodedPath: <#T##String#>) FIND OUT WHERE THE M FILE IS!!! WHERE IS THE H FILE??
 
 let pathGeometry = GMSPath(fromEncodedPath: polylineString)
 //print("Test, Reprint Encoded Path: ", pathGeometry)
 
 let totalDistance = GoogleMapsHelper.findTotalDistanceOfPath(pathGeometry!)
 
 //let midpointCoordinates = GoogleMapsHelper.findMiddlePointInPath(pathGeometry!, totalDistance: totalDistance)
 
 print("The Results I need rnTotoal Disiatnace", totalDistance)
 //print("The Results I need again MidPoint Coordinate", midpointCoordinates)
 */