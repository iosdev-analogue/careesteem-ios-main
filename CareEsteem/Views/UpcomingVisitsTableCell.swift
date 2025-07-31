//
//  UpcomingVisitsTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class UpcomingVisitsTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCheckin: UILabel!
    @IBOutlet weak var lblCheckout: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    @IBOutlet weak var btnCheckin: AGButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var btnRoute: AGButton!
    var ongoingCount = 0
    var voidclosue = {
        
    }
    
    func getCoordinates(for placeID: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: .coordinate, sessionToken: nil) { (place, error) in
            if let error = error {
                print("Error fetching place: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let place = place else {
                print("Place not found for ID: \(placeID)")
                completion(nil)
                return
            }

            completion(place.coordinate)
        }
    }
    
    func getDistanceBetweenPlaceIDs(placeID1: String, placeID2: String, completion: @escaping (String?) -> Void) {
        var coordinate1: CLLocationCoordinate2D?
        var coordinate2: CLLocationCoordinate2D?
        let group = DispatchGroup()

        group.enter()
        getCoordinates(for: placeID1) { coord in
            coordinate1 = coord
            group.leave()
        }

        group.enter()
        getCoordinates(for: placeID2) { coord in
            coordinate2 = coord
            group.leave()
        }
       
        group.notify(queue: .main) {
            if let c1 = coordinate1, let c2 = coordinate2 {
                self.getTravelTime(originCoordinate: c1, destinationCoordinate: c2) { time in
                    completion(time)
                }
//                let distance = self.calculateDistance(coordinate1: c1, coordinate2: c2)
//                completion(distance)
            } else {
                completion(nil)
            }
        }
    }

    func calculateDistance(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2) // Distance in meters
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCheckin.action = {
            if (self.object?.actualStartTime?.first ?? "").isEmpty{
                if convertDateToString(date:Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London")) == self.object?.visitDate{
                    if self.ongoingCount == 0{
                        let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                        vc.visit =  self.object
                        vc.isCheckin = true
                        AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.parentViewController?.view.makeToast("Already one visit ongoing please complete it first")
                    }                    
                }
            }else{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                vc.visit =  self.object
                vc.isCheckin = false
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.btnRoute.action = {
            let placesClient = GMSPlacesClient.shared()
            
            placesClient.lookUpPlaceID(self.object?.placeID ?? "", callback: { (place, error) in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }

                guard let place = place else {
                    print("No place details")
                    return
                }

                let searchedLatitude = place.coordinate.latitude
                let searchedLongitude = place.coordinate.longitude
                
                let url =  "http://maps.apple.com/maps?saddr=&daddr=\(searchedLatitude),\(searchedLongitude))"
                UIApplication.shared.open(URL(string: "\(url)")!,options: [:],
                completionHandler: nil)
            })

        }
    }
    var object:VisitsModel?
    func setupData(model:VisitsModel, isLast: Bool = false, placeID: String? = ""){
        self.object = model
        self.lblName.text = model.clientName
        self.timeLbl.isHidden = isLast
        self.timeLbl.layer.cornerRadius = 10
        self.timeLbl.layer.borderColor = UIColor.darkGray.cgColor
        self.timeLbl.clipsToBounds = true
        self.timeLbl.layer.borderWidth = 1
        
        getDistanceBetweenPlaceIDs(placeID1: model.placeID ?? "", placeID2: placeID ?? "") { distance in
            if let distance = distance {
                DispatchQueue.main.async(execute: {
                    self.timeLbl.text = distance
                })
                print("Distance between places: \(distance) meters")
            } else {
                print("Could not calculate distance.")
            }
        }
//        if var components = model.clientName?.components(separatedBy: " "), components.count > 1 {
//            self.lblName.text = components.last
//        }

        self.lblAddress.text = model.clientAddress
        if let clientPostcode = model.clientPostcode, let clientCity = model.clientCity{
            self.lblAddress.text = ( model.clientAddress ?? "") + "\n" + clientCity + ", " + clientPostcode
        }
        self.lblTime.text = "NA"
        if let totalTime = model.totalPlannedTime, totalTime.count > 0 {
            self.lblTime.text = totalTime
        }
   
        self.lblCount.text = (model.usersRequired?.value as? Int ?? 0).description
        self.lblCheckin.text = "Planned Start Time "+(model.plannedStartTime ?? "")
        self.lblCheckout.text = "Planned End Time "+(model.plannedEndTime ?? "")
        
        if (model.actualStartTime?.first ?? "").isEmpty{
            self.btnCheckin.setTitle("Checkin", for: .normal)
        }else{
            self.btnCheckin.setTitle("Checkout", for: .normal)
        }
    }
    
    func getTravelTime(originCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let origin = "\(originCoordinate.latitude),\(originCoordinate.longitude)"
        let destination = "\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"
        let apiKey = "AIzaSyARBGwVdA-hbVCGTY8VHLRlvTTa8pfo2Go" // Replace with your actual API key
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching directions: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from Directions API")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let routes = json["routes"] as? [[String: Any]],
                   let route = routes.first,
                   let legs = route["legs"] as? [[String: Any]],
                   let leg = legs.first,
                   let duration = leg["duration"] as? [String: Any],
                   let value = duration["text"] as? String {
                    completion(value) // Duration in seconds
                } else {
                    print("Error parsing Directions API response")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

