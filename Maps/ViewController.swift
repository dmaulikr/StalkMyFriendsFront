//
//  ViewController.swift
//  Maps
//
//  Created by Visal Sam on 30/03/2017.
//  Copyright © 2017 Visal Sam. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var ME: UIToolbar!

    @IBOutlet var myLocation: MKMapView!
    
    @IBAction func dropPin(_ sender: UIBarButtonItem) {
        
        let center = CLLocationCoordinate2D ( latitude : myLocation.userLocation.coordinate.latitude, longitude : myLocation.userLocation.coordinate.longitude)
        let position = "Lat:\(myLocation.userLocation.coordinate.latitude) Long:\(myLocation.userLocation.coordinate.longitude)"
        let pin = Pin(coordinate: center, title:position)
        myLocation.addAnnotation(pin)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myLocation.setUserTrackingMode(.follow, animated: true)
        myLocation.delegate = self
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
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let anoView = MKAnnotation(annotation = annotation, reuseidentifier = "pin")
//        anoView.image() = UIImage(named: "")
//        return anoView
//    }
}

