//
//  MapViewController.swift
//  MysqlTest
//
//  Created by César Manuel on 19/01/23.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var selectedLocation : LocationModel?
    
    var old_entry = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.old_entry = (selectedLocation?.name)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
        //wait...
        })
        
        var myCoordinates = CLLocationCoordinate2D()
        
        myCoordinates.latitude = CDouble(self.selectedLocation!.latitude!)!
        myCoordinates.longitude = CDouble(self.selectedLocation!.longitude!)!
        
        let viewRegion: MKCoordinateRegion = MKCoordinateRegion(center: myCoordinates, latitudinalMeters: 750, longitudinalMeters: 750)
        
        self.myMapView.setRegion(viewRegion, animated: true)
        
        let pin: MKPointAnnotation = MKPointAnnotation()
        
        pin.coordinate = myCoordinates
        
        self.myMapView.addAnnotation(pin)
        
        pin.title = selectedLocation!.name
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let url : NSURL
        
        if segue.identifier == "goUpdate"{
            let updateVC = segue.destination as! UpdateViewController
            updateVC.selectedLocation = self.selectedLocation
        }
        
        if segue.identifier == "fromDeletetoMain"{
            
            url = NSURL(string: "https://ioslocations.000webhostapp.com/delete.php")!
            var request = URLRequest(url: url as URL)
            request.httpMethod = "POST" //GET, POST
            
            var dataString = ""
            
            dataString = dataString + "&name=\(self.old_entry)"
            
            let dataD = dataString.data(using: .utf8)
            
            do{
                let deleteJob = URLSession.shared.uploadTask(with: request, from: dataD){ data, response, error in
                    
                    if error != nil{
                        DispatchQueue.main.async{
                            let alert = UIAlertController(title: "App message", message: "Check your Internet connection", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    else{
                        if let unwrappedData = data{
                            let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            print(returnedData as Any)
                            
                            if returnedData == "success"{
                                DispatchQueue.main.async{
                                    let alert = UIAlertController(title: "App message", message: "Seems everything was ok", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                                else{
                                    DispatchQueue.main.async{
                                        let alert = UIAlertController(title: "App message", message: "There was a problem while deleting the place", preferredStyle: .alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                }
 
                            }
                        }
                    }
                deleteJob.resume()
                }
            }

        }
    }




