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
        
        let applicationID = "appId"
        let clientKey = "clientKey"
        
        Fabric.with([Crashlytics()])

        Parse.setApplicationId(applicationID, clientKey: clientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()
        
        //Register for notifications
        if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        } else {
            // iOS7 compatibility
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert | UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound)
        }
        
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
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        FBAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        locationManager!.stopRangingBeaconsInRegion(beaconRegion)
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
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            println("CLAuthorizationStatus.AuthorizedWhenInUse")
            locationManager!.startMonitoringForRegion(beaconRegion)
            
        case CLAuthorizationStatus.Restricted:
            println("CLAuthorizationStatus.Restricted")
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
            self.locationManager?.stopMonitoringForRegion(beaconRegion)
            self.locationManager?.stopRangingBeaconsInRegion(beaconRegion)
            
            self.locationManager?.startMonitoringForRegion(beaconRegion)
            self.locationManager?.startMonitoringVisits()

        default:
            self.locationManager?.startMonitoringForRegion(beaconRegion)
            self.locationManager?.startMonitoringVisits()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {

        if (region.identifier == "com.kiwi.beaconRegion") {
            let notification = UILocalNotification()
            let userDefaults = NSUserDefaults.standardUserDefaults()

            var alertBody: String?
            if !userDefaults.boolForKey("firstNotification") {
                alertBody = "Benvenuto in H-Farm"
                userDefaults.setBool(true, forKey: "firstNotification")
                userDefaults.synchronize()
            } else {
                alertBody = "Sei entrato in un'altra area del progetto Kiwi"
            }
            
            notification.alertBody = alertBody
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        println("Entered in zone \(region.description), Start ranging beacons...")
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
        
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.Unknown}
        
        if (PFUser.currentUser() != nil) {
            
            if (knownBeacons.count > 0) {
                closestBeacon = beacons.first as? CLBeacon
                //println("ClosestBeacon \(closestBeacon?.description)")
                let closestTupleMajMin = (closestBeacon?.major as Int, closestBeacon?.minor as Int)
                switch closestTupleMajMin {
                case (158, 23524):
                    //major:158, minor:23524
                    let alertBody = "Hai trovato Marco"
                    //self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"marco", "alertBody":alertBody])
                    
                case (150, 47059):
                    //major:150, minor:47059
                    let alertBody = "Hai trovato Edoardo"
                    //                self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"edoardo", "alertBody":alertBody])
                    
                case (406, 65259):
                    //major:406, minor:65259
                    let alertBody = "Hai trovato Ennio"
                    //                self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"ennio", "alertBody":alertBody])
                    
                case (333, 24796), (14, 32380):
                    //major:333, minor:24796
                    let alertBody = "Benvenuto in H-Farm"
                    //                self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"hfarm", "alertBody":alertBody])
                    
                case (126, 43175):
                    //major:126, minor:43175
                    let alertBody = "Ti va un caffè?"
                    //                self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"serra", "alertBody":alertBody])
                    
                case (401, 15780):
                    //major:401, minor:15780
                    let alertBody = "Le presentazioni saranno svolte qui"
                    //                self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"convivium", "alertBody":alertBody])
                    
                case (189, 41487):
                    //major:189, minor:41487
                    let alertBody = "La sede di Life"
                    //                self.sendLocalNotification(alertBody)
                    NSNotificationCenter.defaultCenter().postNotificationName("BMFoundPOI", object: nil, userInfo: ["poi":"life", "alertBody":alertBody])
                    
                default:
                    println("Not the correct beacon")
                }
            }
        }
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
