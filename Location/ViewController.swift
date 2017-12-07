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
    @IBOutlet weak var btnRoad: UIBarButtonItem!
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var btnPolylines: UIBarButtonItem!
    @IBOutlet weak var btnChangeMapType: UIBarButtonItem!
    
    let oDirections=Directions()
    let oRequest=requestHttp()
    var locationManager = CLLocationManager()
    var markers = [GMSMarker()]
    let path = GMSMutablePath()
    var polyVisible = false
    var roadVisible = false
    var mapTypeValue = false
    var polyline = GMSPolyline(path: nil)
    
    func srcDirections(_ sender: Any) {
        polyline.map = nil
        let lastMarker = markers.count-1
        if roadVisible == true
        {
            polyVisible = false
            oRequest.url = oDirections.objDirections["basePath"]
            if (markers.count>1){
               
                if (markers.count>2){
                    var parametri = ""
                    for position in markers.dropLast().dropFirst()
                    {
                        parametri=parametri+position.title!+"%7C"
                        print(parametri)
                    }
                    
                    parametri=parametri.substring(to: parametri.index(parametri.startIndex, offsetBy: (parametri.characters.count)-3))
                    oRequest.objParam=[oDirections.objDirections["partenza"]!:markers[0].title!,oDirections.objDirections["arrivo"]!:markers[lastMarker].title!,oDirections.objDirections["waypoints"]!:parametri,oDirections.objDirections["key"]!:oDirections.chiave]
                    
                    oRequest.get {mystatus,myDict in
                        DispatchQueue.main.async{
                            
                            if(mystatus==200)
                            {
                                let path = GMSPath.init(fromEncodedPath: (self.oDirections.getPrevisione(myDict).object(forKey: "strade") as? String)!)

                                self.polyline = GMSPolyline.init(path: path)
                                self.polyline.strokeWidth = 5
                                self.polyline.strokeColor = .blue
                                self.polyline.map = self.googleMapsView
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Attenzione", message: "Errore nella ricerca del tragitto", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                    
                }
                else{
                oRequest.objParam=[oDirections.objDirections["partenza"]!:markers[0].title!,oDirections.objDirections["arrivo"]!:markers[lastMarker].title!,oDirections.objDirections["key"]!:oDirections.chiave]
                    
                    oRequest.get {mystatus,myDict in
                        DispatchQueue.main.async{
                            
                            if(mystatus==200)
                            {
                                let path = GMSPath.init(fromEncodedPath: (self.oDirections.getPrevisione(myDict).object(forKey: "strade") as? String)!)
                                
                                self.polyline = GMSPolyline.init(path: path)
                                self.polyline.strokeWidth = 5
                                self.polyline.strokeColor = .blue
                                self.polyline.map = self.googleMapsView
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Attenzione", message: "Errore nella ricerca del tragitto", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            else
            {
                let alert = UIAlertController(title: "Attenzione", message: "Seleizonare almeno due posizioni", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func polylines() {
        if (markers.count>1){
            polyline.map = nil
            if polyVisible == true
            {
                roadVisible = false
                polyline = GMSPolyline(path: path)
                polyline.strokeColor = .red
                polyline.strokeWidth = 5
                polyline.map = googleMapsView
            }
        }
        else
        {
            let alert = UIAlertController(title: "Attenzione", message: "Seleizonare almeno due posizioni", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func EliminaMarker(_ sender: UIBarButtonItem) {
        googleMapsView.clear()
        polyVisible = false
        roadVisible = false
        polyline.map = nil
        print (markers.count)
        markers.removeAll()
        path.removeAllCoordinates()
    }
    
    @IBAction func ViewDirection(_ sender: UIBarButtonItem) {
        if(roadVisible == false){
            roadVisible = true
        }
        else{
            roadVisible = false
        }
        srcDirections(markers)
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
    
    @IBAction func ChangeMapType(_ sender: UIBarButtonItem) {
        
        if(mapTypeValue == false){
            self.googleMapsView.mapType = .hybrid
            mapTypeValue = true
        }
        else{
            self.googleMapsView.mapType = .normal
            mapTypeValue = false
        }
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
        marker.icon = UIImage(named: "marker")
        marker.snippet = "lat: \(place.coordinate.latitude) ,long: \(place.coordinate.longitude)"
        marker.map = googleMapsView
        markers.append(marker)
        path.add(marker.position)
        
        if polyVisible == true
        {
            polylines()
            polyVisible = true
        }
        
        if roadVisible == true
        {
            srcDirections(markers)
            roadVisible = true
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
        markers.removeAll()
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

