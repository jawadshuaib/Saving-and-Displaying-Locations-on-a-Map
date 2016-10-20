//
//  MapVC.swift
//  Saving Places on a Map
//
//  Created by Jawad Shuaib on 2016-10-20.
//  Copyright © 2016 Jawad Shuaib. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    // this data is coming from the segue
    private var _locations = [Location]()
    private var _filePath = ""
    private var _currentLocation = Location()
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMap()
        addPressGesture()
    }

    private func loadMap () {
        if currentLocation.name != "" {
            // Convert String to Float
            let latitude = Float(currentLocation.latitude)
            let longitude = Float(currentLocation.longitude)
            
            let span = MKCoordinateSpanMake(0.09, 0.09)
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!), CLLocationDegrees(longitude!))
            let region = MKCoordinateRegion (center: coordinate, span: span)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = currentLocation.name
            
            self.myMapView.setRegion (region, animated:true)
            self.myMapView.addAnnotation(annotation)
        }
    }
    
    private func addPressGesture () {
        let pressGesture = UILongPressGestureRecognizer (target: self, action: #selector(MapVC.saveNewLocation(gesture:)))
        
        // set a minimum press duration to 2 seconds
        pressGesture.minimumPressDuration = 2
        myMapView.addGestureRecognizer(pressGesture)
        
    }
    
    @objc private func saveNewLocation (gesture: UIGestureRecognizer) {
        // we use this to make sure we only call this function once
        // otherwise it will be called both when we press and release press
        if gesture.state == UIGestureRecognizerState.began {
            // x, y coordinates where we pressed
            let touchLocation = gesture.location(in: self.myMapView)
            // lat, lng coordinates on the map where we pressed
            let coordinate = self.myMapView.convert(touchLocation, toCoordinateFrom: self.myMapView)
            
            let location = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            // how to get name of the location
            // begin geocoding
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                if error != nil {
                    // we have a problem
                }
                else {
                    if let placemark = placemarks?[0] {
                        // street information
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " ";
                        }
                        
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                }
                
                if title == "" {
                    title = "Unable to resolve title"
                }
                
                let annotation = MKPointAnnotation ()
                annotation.coordinate = coordinate
                annotation.title = title
                
                self.myMapView.addAnnotation(annotation)
                
                let newLocation = Location (placeName: title, lat: String(coordinate.latitude), long: String (coordinate.longitude))
                self.locations.append (newLocation)
                
                self.saveData()
            })
            
        }
    }
    
    private func saveData() {
        NSKeyedArchiver.archiveRootObject (locations, toFile: filePath)
        
    }
    
    var locations: [Location] {
        get {
            return _locations
        }
        set {
            _locations = newValue
        }
    }
    
    var filePath: String {
        get {
            return _filePath
        }
        set {
            _filePath = newValue
        }
    }
    
    var currentLocation: Location {
        get {
            return _currentLocation
        }
        set {
            _currentLocation = newValue
        }
    }
}
