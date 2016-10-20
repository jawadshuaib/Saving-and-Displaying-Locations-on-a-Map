//
//  Location.swift
//  Saving Places on a Map
//
//  Created by Jawad Shuaib on 2016-10-20.
//  Copyright © 2016 Jawad Shuaib. All rights reserved.
//

import Foundation

class Location: NSObject, NSCoding {
    
    struct Keys {
        static let Name = "name"
        static let Latitude = ""
        static let Longitude = ""
    }
    
    private var _name = ""
    private var _latitude = ""
    private var _longitude = ""
    
    override init () {}
    
    init (placeName: String, lat: String, long: String) {
        _name = placeName
        _latitude = lat
        _longitude = long
    }
    
    // This is the function automatically called by UnArchiver
    required init (coder decoder: NSCoder) {
        
        if let nameObj = decoder.decodeObject(forKey: Keys.Name) as? String {
            _name = nameObj
        }
        
        if let latObj = decoder.decodeObject(forKey: Keys.Latitude) as? String {
            _latitude = latObj
        }
        
        if let longObj = decoder.decodeObject(forKey: Keys.Longitude) as? String {
            _longitude = longObj
        }
    }
    
    // NSArchiver will automatically run this function
    func encode (with coder: NSCoder) {
        coder.encode(_name, forKey: Keys.Name)
        coder.encode(_latitude, forKey: Keys.Latitude)
        coder.encode(_longitude, forKey: Keys.Longitude)
    }
    
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    var latitude: String {
        get {
            return _latitude
        }
        set {
            _latitude = newValue
        }
    }
    
    var longitude: String {
        get {
            return _longitude
        }
        set {
            _longitude = newValue
        }
    }
    
    
}
