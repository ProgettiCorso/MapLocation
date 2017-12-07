//
//  DirectionsRows.swift
//  Location
//
//  Created by Andrea Ceroli on 06/12/17.
//  Copyright © 2017 Aesys. All rights reserved.
//

import Foundation

class Directions {
    
    var selezione = " "
    let partenza="origin"
    let arrivo="destination"
    let mode="mode"
    let waypoints = "waypoints"
    let key="key"
    let chiave="AIzaSyDLlp6d5xSpl3fctIkKM6NWCG_QwqirVHk"
    let par_basePath="https://maps.googleapis.com/maps/api/directions/json"
    
    
    var objDirections: [String:String] {
        return [
            "basePath":self.par_basePath,
            "partenza": self.partenza,
            "arrivo": self.arrivo,
            "waypoints": self.waypoints,
            "key": self.key
        ]
    }
    
    func getPrevisione(_ DicResponse:NSDictionary) -> NSDictionary {
        
        return [
            "strade":((((DicResponse.object(forKey: "routes") as! NSArray)[0] as AnyObject).object(forKey: "overview_polyline") as! NSDictionary)as AnyObject).object(forKey: "points") as! String,
        ]
    }
    
    
    
//    https://maps.googleapis.com/maps/api/directions/json?origin=Boston,MA&destination=Concord,MA&waypoints=Charlestown,MA|Lexington,MA&key=YOUR_API_KEY
//    https://maps.googleapis.com/maps/api/directions/json?origin=Perano&destination=Bari&waypoints=Pescara|Avezzano|L\'Aquila|Roma|Napoli&key=AIzaSyDLlp6d5xSpl3fctIkKM6NWCG_QwqirVHk
//    
//    "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
//    
    
}


