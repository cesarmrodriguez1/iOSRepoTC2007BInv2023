//
//  UpdateViewController.swift
//  MysqlTest
//
//  Created by César Manuel on 20/01/23.
//

import Foundation
import UIKit

class UpdateViewController: UIViewController {
    
    
    @IBOutlet weak var textName: UITextField!
    
    
    @IBOutlet weak var textAddress: UITextField!
    
    
    @IBOutlet weak var textLatitude: UITextField!
    
    
    @IBOutlet weak var textLongitude: UITextField!
    
    
    var selectedLocation : LocationModel?
    
    var old_entry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.textName.text = self.selectedLocation?.name
        self.textAddress.text = self.selectedLocation?.address
        self.textLatitude.text = self.selectedLocation?.latitude
        self.textLongitude.text = self.selectedLocation?.longitude
        
        self.old_entry = (self.selectedLocation?.name)!
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let url: NSURL
        
        if segue.identifier == "goMainViewController"{
            url = NSURL(string: "https://ioslocations.000webhostapp.com/update.php")!
            
            var request = URLRequest(url: url as URL)
            request.httpMethod = "POST" //GET, POST
            
            var dataString = ""
            
            dataString = dataString + "&old_entry=\(self.old_entry)"
            dataString = dataString + "&name=\(self.textName.text!)"
            dataString = dataString + "&address=\(self.textAddress.text!)"
            dataString = dataString + "&latitude=\(self.textLatitude.text!)"
            dataString = dataString + "&longitude=\(self.textLongitude.text!)"
            
            let dataD = dataString.data(using: .utf8)
            
            do{
                let updateJob = URLSession.shared.uploadTask(with: request, from: dataD){ data, response, error in
                    
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
                                        let alert = UIAlertController(title: "App message", message: "There was a problem while updating place", preferredStyle: .alert)
                                        
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                }
 
                            }
                        }
                    }
                updateJob.resume()
                }
            }
            
        }
    }
    

