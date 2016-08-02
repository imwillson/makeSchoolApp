//
//  Steps.swift
//  test-API
//
//  Created by Willson Li on 7/28/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol Copying { init(original: Self)}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

struct Steps {
    var distanceTillNextCoordinate: Int
    var durationTillNextCoordinate: Int
    var coordinateLat: Double
    var coordinateLng: Double
    var summationTime: Int
    
    init(json: JSON) {
        self.distanceTillNextCoordinate = json["distance"]["value"].intValue
        self.durationTillNextCoordinate = json["duration"]["value"].intValue
        self.coordinateLat = json["start_location"]["lat"].doubleValue
        self.coordinateLng = json["start_location"]["lng"].doubleValue
        self.summationTime = 0
        
    }
    
//    required init(original: Steps) {
//        distanceTillNextCoordinate = original.distanceTillNextCoordinate
//        durationTillNextCoordinate = original.durationTillNextCoordinate
//        coordinateLat = original.coordinateLat
//        coordinateLng = original.coordinateLng
//        summationTime = original.summationTime
//    }
    
    //let stepsData = json["routes"][0]["legs"][0]["steps"][0]["travel_mode"].stringValue
    
    
}

/*
 
 let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
 // This code will call the iTunes top 25 movies endpoint listed above
 Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
 switch response.result {
 case .Success:
 if let value = response.result.value {
 let json = JSON(value)
 
 let randomMovieData = json["feed"]["entry"][Int(arc4random_uniform(UInt32(25)))]
 self.randomMovie = Movie(json: randomMovieData)
 
 
 self.rightsOwnerLabel.text = self.randomMovie.rightsOwner
 self.movieTitleLabel.text = self.randomMovie.name
 self.releaseDateLabel.text = self.randomMovie.releaseDate
 self.priceLabel.text = String(self.randomMovie.price)
 self.loadPoster(self.randomMovie.poster)
 
 //self.viewOniTunesPressed(randomMovie.link)  //
 
 //print(randomMovie.poster)
 */

