//
//  Capital.swift
//  SearchAnythingApp
//
//  Created by Kiran Sonne on 29/09/22.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
  
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
     
     
    init(title:String,coordinate:CLLocationCoordinate2D,info:String)
    {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        
    }
    
}
