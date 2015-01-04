//
//  BMLocationManager.swift
//  kiwi
//
//  Created by Matteo Comisso on 04/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import Foundation
import CoreLocation

class BMLocationManager: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance : BMLocationManager {
        struct Static {
            static let instance : BMLocationManager = BMLocationManager()
        }
        return Static.instance
    }
    
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "96A1736B-11FC-85C3-1762-80DF658F0B29"), identifier: "com.kiwi.beaconRegion")
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println()
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println()
    }
    
}

//MARK:- Beacons Methods
extension BMLocationManager {
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println()
    }
    
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        println()
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println()
    }
}