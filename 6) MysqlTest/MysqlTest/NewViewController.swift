//
//  NewViewController.swift
//  MysqlTest
//
//  Created by César Manuel on 19/01/23.
//

import UIKit

class NewViewController: UIViewController {
    
    
    @IBOutlet weak var textName: UITextField!
    
    
    @IBOutlet weak var textAddress: UITextField!
    
    
    @IBOutlet weak var textLatitude: UITextField!
    
    
    @IBOutlet weak var textLongitude: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backMain"{
            
            let url = NSURL(string: "https://ioslocations.000webhostapp.com/insert.php")
            
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            
            var dataString = ""
            
            dataString = dataString + "&name=\(self.textName.text!)"
            dataString = dataString + "&address=\(self.textAddress.text!)"
            dataString = dataString + "&latitude=\(self.textLatitude.text!)"
            dataString = dataString + "&longitude=\(self.textLongitude.text!)"
            
            let dataD =  dataString.data(using: .utf8)
            
            do{
                
                let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD){ data, response, error in
                    
                    if error != nil {
                        DispatchQueue.main.async{
                            let alert = UIAlertController(title: "App message", message: "Check your Internet Connection", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else{
                        if let unwrappedData = data{
                            let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            print(returnedData as Any)
                            
                            if returnedData! == "success"{
                                DispatchQueue.main.async{
                                    let alert = UIAlertController(title: "App message", message: "Data was saved in database", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            else{
                                
                                DispatchQueue.main.async{
                                    let alert = UIAlertController(title: "App message", message: "Data could not be inserted", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            
                        }
                    }
                }
                uploadJob.resume()

            }
        }
    }
    
    
    
}
