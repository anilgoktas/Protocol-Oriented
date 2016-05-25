//
//  LocationUsableType.swift
//
//
//  Created by Anıl Göktaş on 5/12/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol LocationUsableType: CLLocationManagerDelegate {
    var locationManager: CLLocationManager { get set }
    
    func configureLocationManager()
}

extension LocationUsableType where Self: UIViewController {
    
    func configureLocationManager() {
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 10.0
            locationManager.startUpdatingLocation()
            
        case .Restricted, .Denied:
            let alertController = UIAlertController(title: "Location Access Disabled", message: "In order to use app properly, please open settings and set location access to 'WhenInUse'.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Settings", style: .Default) { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString)
                where UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}