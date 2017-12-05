//
//  ViewController.swift
//  Location
//
//  Created by Andrea Ceroli on 04/12/17.
//  Copyright © 2017 Aesys. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var btnElimina: UIBarButtonItem!
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    @IBOutlet weak var btnPolylines: UIBarButtonItem!
    var locationManager = CLLocationManager()
    var markers = [GMSMarker()]
    let path = GMSMutablePath()
    var polyVisible = false
    var polyline = GMSPolyline(path: nil)
    @IBAction func EliminaMarker(_ sender: UIBarButtonItem) {
            googleMapsView.clear()
    }
    
    func polylines() {
        if (markers.count>2){
//            polyline.map = nil
            if polyVisible == true
            {
            polyline = GMSPolyline(path: path)
            polyline.strokeColor = .red
            polyline.strokeWidth = 5.0
            polyline.map = googleMapsView
            }
            else{
            polyline.map = nil
            }
        }
        else
        {
        let alert = UIAlertController(title: "Attenzione", message: "Seleizonare almeno due posizioni", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`))
        self.present(alert, animated: true, completion: nil)
    }
    }
    
    
    
    @IBAction func PolylineMarkers(_ sender: UIBarButtonItem) {
        if(polyVisible == false){
            polyVisible = true
        }
        else{
            polyVisible = false
        }
        
        polylines()
    }
    
    @IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 6.0)
        self.googleMapsView.camera = camera
        self.dismiss(animated: true, completion: nil)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        marker.snippet = "lat: \(place.coordinate.latitude) ,long: \(place.coordinate.longitude)"
        marker.map = googleMapsView
        markers.append(marker)
        path.add(marker.position)
        
        if polyVisible == true
        {
            polylines()
            polyVisible = true
        
        }
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

