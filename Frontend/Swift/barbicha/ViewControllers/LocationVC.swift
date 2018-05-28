//
//  LocationVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController {

    static func instantiate(using coordinator: AppCoordinator, show barbershop: Barbershop) -> LocationVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: LocationVC.self) {
            
            controller.coordinator = coordinator
            controller.barbershop = barbershop
            return controller
            
        } else {return nil}
        
    }
    
    private var locationManager = CLLocationManager()
    private var coordinator: AppCoordinator!
    private var barbershop: Barbershop!
    private var mapItens: [MKMapItem] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblDistances: UILabel!
    @IBOutlet weak var buttonDirections: UIButton!
    @IBOutlet weak var buttonBack: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.lblDistances.text = ""
        self.mapView.delegate = self
        self.buttonDirections.layer.cornerRadius = 15
        self.buttonDirections.clipsToBounds = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.showCollectionInMap()
        
    }
    
    private func configLocationManager() -> Void {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    private func showCollectionInMap() -> Void {

        let values = [self.barbershop]
        
        var annotations: [MKPointAnnotation] = []
        values.forEach {

            if let location = $0?.location {
                
                let clLocation = CLLocation(latitude: location.0, longitude: location.1)
                
                let placeMk = MKPlacemark(coordinate: clLocation.coordinate)
                let mapItem = MKMapItem(placemark: placeMk)
                mapItem.name = $0?.name
                
                self.mapItens.append(mapItem)
                
                let shopAnnotation = MKPointAnnotation()
                shopAnnotation.title = $0?.name
                shopAnnotation.coordinate = clLocation.coordinate
                
                annotations.append(shopAnnotation)
                
            }

        }

        self.mapView.showAnnotations(annotations, animated: true)
        
        let region = self.regionForAnnotations(annotations: annotations)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func buttonDirectionsClicked(_ sender: UIButton) {
        
        self.configLocationManager()
        
    }
    
    @IBAction func buttonBackClicked(_ sender: UIButton) {self.dismiss(animated: true, completion: nil)}
    
    private func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        
        var minLat:Double = 90.0, maxLat: Double = -90.0
        var minLon: Double = 180.0, maxLon: Double = -180.0
        
        for item in annotations {
            
            if item.coordinate.latitude < minLat {minLat = item.coordinate.latitude}
            if item.coordinate.latitude > maxLat {maxLat = item.coordinate.latitude}
            if item.coordinate.longitude < minLon {minLon = item.coordinate.longitude}
            if item.coordinate.longitude > maxLon {maxLon = item.coordinate.longitude}
            
        }
        
        let center = CLLocation(latitude: (minLat + maxLat) / 2.0, longitude: (minLon + maxLon) / 2.0)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLon - minLon) * 1.3)
        let region = MKCoordinateRegion(center: center.coordinate, span: span)
        return region
        
    }
    
    private func drawRoutes(with initial: CLLocation) -> Void {
        
        let formatter = MKDistanceFormatter()
        
        let myPlacemk = MKPlacemark(coordinate: initial.coordinate)
        let myMapItem = MKMapItem(placemark: myPlacemk)
        
        let source = MKPointAnnotation()
        source.coordinate = initial.coordinate
        source.title = "Sua Localização"
        self.mapView.addAnnotation(source)

        var annotations = self.mapView.annotations
        annotations.append(source)
        
        let region = self.regionForAnnotations(annotations: annotations)
        self.mapView.setRegion(region, animated: true)

        for item in self.mapItens {
            
            let request = MKDirectionsRequest()
            request.source = myMapItem
            request.destination = item
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                
                guard let response = response else {
                    if let error = error {debugPrint("Error -> \(error)")}
                    return
                }
                
                let route = response.routes[0]
                let distance = route.distance
                DispatchQueue.main.async {
                    
                    let area = MKMapRectUnion(self.mapView.visibleMapRect, route.polyline.boundingMapRect)
                    self.mapView.setVisibleMapRect(area, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: true)
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                    
                    self.lblDistances.text?.append("\(item.name ?? "NoName") - \(formatter.string(fromDistance: distance)) \n")
                    
                }
                
            }

        }

    }
    
}

extension LocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 { polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 2 { polylineRenderer.strokeColor = UIColor.green.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 3 { polylineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.75)}
            polylineRenderer.lineWidth = 5
        }
        
        return polylineRenderer
        
    }
    
}

extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        self.drawRoutes(with: locations[0])
        
    }
    
}

