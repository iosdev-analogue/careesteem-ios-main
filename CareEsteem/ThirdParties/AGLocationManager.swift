//
//  LocationManager.swift
//  KZ
//
//  Created by iOSTemplate on 12/6/17.
//  Copyright © 2017 KZ. All rights reserved.
//

import UIKit
import CoreLocation

struct Location {
    let location: CLLocation
    let placeMark: AGPlacemark
}

enum LocationStatus{
    case success(CLLocation)
    case failer(Error?)
}

enum LocationType{
    case oneShot
    case countinue
}

class AGLocationManager: NSObject, CLLocationManagerDelegate {
    typealias LocationResult = ((LocationStatus) -> ())
    typealias CountinuesLocationResult = (UIViewController,LocationResult)
    
    static let countinues = AGLocationManager(type: .countinue)
    static let oneTime = AGLocationManager(type: .oneShot)
    
    var locationManager: CLLocationManager
    static var lastLocation: CLLocationCoordinate2D?
    fileprivate var type: LocationType
    
    fileprivate var countinuesLocationResult: [CountinuesLocationResult] = []
    fileprivate var oneTimeLocationResult: LocationResult? = nil
    
    init(type: LocationType) {
        
        self.type = type
        self.locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if locationManager.responds(to: #selector(requestAlwaysAuthorization)) {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocation(_ viewControler: UIViewController? = nil, complitionHandler: @escaping LocationResult){
        switch self.type {
        case .oneShot:
            oneTimeLocationResult = complitionHandler
            break
            
        case .countinue:
            guard let vc = viewControler else {
                fatalError("viewContoller is set")
            }
            countinuesLocationResult.append((vc, complitionHandler))
            break
        }
        
        self.locationManager.startUpdatingLocation()
        self.locationServicesEnabled(error: nil)
    }
    
    func removeUpdateObserver(_ vc: UIViewController) {
        for i in 0..<countinuesLocationResult.count {
            if countinuesLocationResult[i].0 == vc {
                countinuesLocationResult.remove(at: i)
            }
        }
        
        if self.countinuesLocationResult.count == 0 {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    @objc fileprivate func requestAlwaysAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            AGAlertBuilder(withAlert: "Oops Kilowat Does Not Have Access To Your Location", message: "You Can Change Access By Going To Your Settings")
                .addAction(with: "Not Now", style: .default, handler: { _ in
                
                })
                .defaultAction(with: "Settings", handler: { _ in
                    AppDelegate.shared.openSettingForApp()
                })
                .show()
            
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            
            break
        default:break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            if let oneTime = oneTimeLocationResult {
                oneTime(.success(loc))
                oneTimeLocationResult = nil
                AGLocationManager.lastLocation = loc.coordinate
                locationManager.stopUpdatingLocation()
            }
            else{
                for multiple in countinuesLocationResult {
                    multiple.1(.success(loc))
                }
            }
            
            debugPrint("Current Location \(loc.coordinate.longitude), \(loc.coordinate.latitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        self.locationServicesEnabled(error: error)
    }
    
    func locationServicesEnabled(error: Error?){
        if !CLLocationManager.locationServicesEnabled(){
            AGAlertBuilder(withAlert: "Location Update Error", message: error?.localizedDescription)
                .defaultAction(with: "Settings", handler: { _ in
                    AppDelegate.shared.openSettingForApp()
                })
                .cancelAction(with: "Cencel", handler: { _ in })
                .show()
        }
        
        if error != nil {
            if let oneTime = oneTimeLocationResult {
                oneTime(.failer(error))
            }
            else{
                for multiple in countinuesLocationResult {
                    multiple.1(.failer(error))
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            requestAlwaysAuthorization()
            break
        case .notDetermined,.restricted:
            break
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        }
    }
}

extension CLLocation {
    var latitude: CLLocationDegrees {
        get { return coordinate.latitude }
    }
    
    var longitude: CLLocationDegrees {
        get { return coordinate.longitude }
    }
    
    func getAddress(withLocation handler: @escaping (Location) -> Void){
        CLGeocoder().reverseGeocodeLocation(self) { (placemarks, error) in
            if let placeMark = placemarks?.last {
                debugPrint(placeMark.debugDescription)
                handler(Location(location: self, placeMark: AGPlacemark(placemark: placeMark)))
            }
        }
    }
}

class AGPlacemark {
    var state: String
    var country: String
    var areasOfInterest: String
    var streetName: String
    var streetNumber: String
    var name: String
    var city: String
    var locality: String
    var zipCode: String
    var countryCode: String
    var formattedAddressLines: String
    
    init(placemark: CLPlacemark) {
        self.state = placemark.administrativeArea ?? ""
        self.country = placemark.country ?? ""
        self.areasOfInterest = (placemark.areasOfInterest ?? [""]).joined(separator: ",")
        self.name = placemark.name ?? ""
        self.streetName = placemark.thoroughfare ?? ""
        self.streetNumber = placemark.subThoroughfare ?? ""
        self.city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
        self.locality = placemark.subLocality ?? ""
        self.zipCode = placemark.postalCode ?? ""
        self.countryCode = placemark.isoCountryCode ?? ""
        self.formattedAddressLines = ((placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.joined(separator: ",")) ?? ""
    }
}

