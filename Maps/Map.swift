//
//  Map.swift
//  Maps
//
//  Created by Visal Sam on 26/05/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit
import MapKit

class Map: UIViewController, MKMapViewDelegate {

    @IBOutlet var myLocation: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myLocation.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
