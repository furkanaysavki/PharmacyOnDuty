//
//  DetailsVC.swift
//  PharmacyOnDuty
//
//  Created by Furkan Ayşavkı on 18.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class DetailsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var eczaneAdi: UILabel!
    
    @IBOutlet weak var eczaneNumara: UILabel!
    
    @IBOutlet weak var eczaneAdres: UILabel!
    
    @IBOutlet weak var phoneIcon: UIImageView!
    
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBOutlet weak var eczaIcon: UIImageView!
    
        var selectedName = ""
        var selectedAdrress = ""
        var selectedPhone = ""
        var selectedLoc = ""
    
   
   
   
  
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
      
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
    
        eczaneAdi.text = "\(selectedName) Eczanesi".capitalized
        eczaneNumara.text = selectedPhone
        eczaneAdres.text = selectedAdrress
        let base = selectedLoc.components(separatedBy: ",")
        let latitude = Double(base[0])!
        let longitude = Double(base[1])!
        
        
        let annotation = MKPointAnnotation()
        annotation.title = "\(String(describing: selectedName.capitalized)) Eczanesi"
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

      
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let base = selectedLoc.components(separatedBy: ",")
        let latitude = Double(base[0])!
        let longitude = Double(base[1])!
        
        if selectedName != nil {
            
            var requestLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = self.selectedName
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    
    
}
