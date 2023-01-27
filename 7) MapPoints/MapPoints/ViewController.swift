//
//  ViewController.swift
//  MapPoints
//
//  Created by César Manuel on 13/01/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var artworks: [Artwork] = []
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myMapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        let oahuCenter = CLLocation(latitude: 21.4765, longitude: -157.9647)
        
        let region = MKCoordinateRegion(
            center: oahuCenter.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        
        myMapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),animated: true
        )
        
        let zoomRange =  MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        
        myMapView.setCameraZoomRange(zoomRange, animated: true)
        
        /*
         let artwork = Artwork(
         title: "King David Kalakaua",
         locationName: "Waikiki Gateway Park",
         discipline: "Sculpture",
         coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661)
         )
         
         myMapView.addAnnotation(artwork)
         */
        
        myMapView.centerToLocation(initialLocation)
        
        myMapView.register(
            ArtworkMarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialData()
        myMapView.addAnnotations(artworks)
        
        
    }
    
    private func loadInitialData(){
        guard let fileName = Bundle.main.url(forResource: "PublicArt", withExtension: "geojson"),
              let artworkData = try? Data(contentsOf: fileName) else { return}
        
        do{
            let features = try MKGeoJSONDecoder()
                .decode(artworkData)
                .compactMap{ $0 as? MKGeoJSONFeature}
            
            let validWorks = features.compactMap(Artwork.init)
            
            artworks.append(contentsOf: validWorks)
        }catch{
            print("An error has occurred: \(error)")
        }
    }
}

extension ViewController: MKMapViewDelegate{
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard let annotation = annotation as? Artwork else { return nil}
        
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else{
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    */
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        guard let artwork = view.annotation as? Artwork else { return}
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
        
    }
}

private extension MKMapView{
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        setRegion(coordinateRegion, animated: true)
    }
    
}

