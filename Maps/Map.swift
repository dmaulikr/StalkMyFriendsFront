//
//  Map.swift
//  Maps
//
//  Created by Visal Sam on 26/05/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class Map: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet var myLocation: MKMapView!
    
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Show my position in Map
        myLocation.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        // Core Location Manager asks for GPS location
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startMonitoringSignificantLocationChanges()

        //Our coordinates
        let latitude = locManager.location?.coordinate.latitude
        let longitude = locManager.location?.coordinate.longitude
        
        //Calcul Distance
        let coordinate1 = CLLocation(latitude: latitude!, longitude: longitude!)
        
        let coordinate2 = CLLocation(latitude: 48.85, longitude: 2.36)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        
        //Round result
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let distanceKm = round((distanceInMeters/1000) * multiplier) / multiplier
        
        //Put a Pin
        let center = CLLocationCoordinate2D ( latitude : 48.85, longitude : 2.36)
        let pin = Pin(coordinate: center, title: "Henry Dist: \(distanceKm) Km ")
        myLocation.addAnnotation(pin)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView ( _ mapView : MKMapView , didUpdate userLocation : MKUserLocation ) {
        let center = CLLocationCoordinate2D ( latitude : userLocation.coordinate.latitude, longitude : userLocation.coordinate.longitude)
        let width = 1000.0 // meters
        let height = 1000.0
        let region = MKCoordinateRegionMakeWithDistance (center, width, height )
        mapView.setRegion(region, animated : true )
    }

}
