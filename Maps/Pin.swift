//
//  Pin.swift
//  Maps
//
//  Created by Visal Sam on 30/03/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import Foundation
import MapKit

class Pin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title : String){
        self.coordinate = coordinate
        self.title = title
    }
}
