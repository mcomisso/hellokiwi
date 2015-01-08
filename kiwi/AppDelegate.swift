//
//  AppDelegate.swift
//  kiwi
//
//  Created by Matteo Comisso on 03/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var beaconRegion: CLBeaconRegion?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let applicationID = "TYLfPuBMMfuiFBseC5JsjfsFhELw1jCAnb20rESK"
        let clientKey = "E8GnhIGzYnHbXYyFjy1MgHAJ5O3wIADhtdJKmkdY"
        
        Fabric.with([Crashlytics()])

        Parse.setApplicationId(applicationID, clientKey: clientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()
        
        //MARK:- CoreLocation
        let uuidString = "96A1736B-11FC-85C3-1762-80DF658F0B29"
        let beaconIdentifier = "com.kiwi.beaconRegion"
        let beaconUUID:NSUUID? = NSUUID(UUIDString: uuidString)
        
        beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)

        locationManager = CLLocationManager()
        locationManager!.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
                locationManager!.requestAlwaysAuthorization()
            }
        }
        locationManager!.startMonitoringForRegion(beaconRegion)
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//BEACON EXTENSION
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.Authorized:
            locationManager!.startMonitoringForRegion(beaconRegion)

        case CLAuthorizationStatus.NotDetermined, CLAuthorizationStatus.Denied:
            println("not determined or denied")
            
        default:
            println("default case")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        
        switch state {
        case CLRegionState.Inside:
            self.locationManager?.startRangingBeaconsInRegion(beaconRegion)
            self.locationManager?.startMonitoringVisits()
            
        case CLRegionState.Outside:
            self.locationManager?.stopRangingBeaconsInRegion(beaconRegion)
            self.locationManager?.stopMonitoringVisits()
            
        case CLRegionState.Unknown:
            self.locationManager?.stopRangingBeaconsInRegion(beaconRegion)
            self.locationManager?.startMonitoringForRegion(beaconRegion)
            self.locationManager?.startMonitoringVisits()

        default:
            self.locationManager?.startMonitoringForRegion(beaconRegion)
            self.locationManager?.startMonitoringVisits()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered in zone \(region.description), Starting ranging beacons...")
        locationManager!.startRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Stopping ranging...")
        locationManager!.stopRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        //Save on parse
        //var visitPFObject = PFObject(className: "")?
        println(visit.description)
        
    }
    
    //Ranged beacons: Switch and send signals if the found beacon is correct
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        var closestBeacon: CLBeacon?
        
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.Unknown && $0.proximity != CLProximity.Far}
        
        if (knownBeacons.count > 0) {
            closestBeacon = beacons.first as? CLBeacon
            println("ClosestBeacon \(closestBeacon?.description)")
            let closestMinor = closestBeacon?.minor as Int
            
            switch closestMinor {
            case 161:
                let alertBody = "Hai trovato Marco"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"marco", "alertBody":alertBody])

            case 165:
                let alertBody = "Hai trovato Edoardo"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"edoardo", "alertBody":alertBody])
            
            case 166:
                let alertBody = "Hai trovato Ennio"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"ennio", "alertBody":alertBody])
            
            case 167:
                let alertBody = "Benvenuto in H-Farm"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"hfarm", "alertBody":alertBody])
            
            case 168:
                let alertBody = "Ti va un caffè?"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"serra", "alertBody":alertBody])
            
            case 169:
                let alertBody = "Le presentazioni saranno svolte qui"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"convivium", "alertBody":alertBody])
            
            case 170:
                let alertBody = "La sede di Life"
//                self.sendLocalNotification(alertBody)
                NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"life", "alertBody":alertBody])
            
            default:
                println("Not the correct beacon")
            }
        }
    }
    
    func sendLocalNotification(alertBody: String) {
        //Print a local notification UI
        let notification = UILocalNotification()
        notification.alertBody = alertBody
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    //ERROR HANDLING
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("FAIL \(error.localizedDescription, error.localizedFailureReason)")
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("FAIL \(error.localizedDescription, error.localizedFailureReason, region.description)")
    }
    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("FAIL \(error.localizedDescription, error.localizedFailureReason, region.description)")
    }
}
