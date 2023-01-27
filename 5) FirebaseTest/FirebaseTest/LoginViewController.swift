//
//  LoginViewController.swift
//  FirebaseTest
//
//  Created by César Manuel on 17/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    

    @IBOutlet weak var textEmail: UITextField!
    
    
    @IBOutlet weak var textPassword: UITextField!
    
    var isAccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SignUpEmployee(_ sender: Any) {
        if textEmail.text?.isEmpty == true || textPassword.text?.isEmpty == true{
            displayAlertMessage(message: "You have empty textfields")
        }
        else{
            if verifyEmail(email: textEmail.text!){
                let sgManager = FirebaseAuthManager()
                
                sgManager.createEmployee(email: textEmail.text!, password: textPassword.text!){ [weak self] (success) in
                    
                    var message = ""
                    
                    guard let `self` = self else { return}
                    
                    if success{
                        message = "Employee was created successfully"
                    }
                    else{
                        message = "There was problem while creating employee"
                    }
                    self.displayAlertMessage(message: message)
                }
            }
            else {
                self.displayAlertMessage(message: "Email is wrong!")
            }
        }
    }
    
    
    func displayAlertMessage(message: String){
        let alertController = UIAlertController(title: "App message", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "logIn"{
            if textEmail.text?.isEmpty == true || textPassword.text?.isEmpty == true{
                displayAlertMessage(message: "Please complete textfields")
            }
            else{
                if verifyEmail(email: textEmail.text!){
                    let loginManager = FirebaseAuthManager()
                    
                    loginManager.logIn(email: textEmail.text!, password: textPassword.text!){ [weak self] (success) in
                        
                        guard let `self` = self else { return}
                        
                        if (success){
                            self.isAccess = true
                            UserDefaults.standard.set(self.textEmail.text!, forKey: "loggedUser")
                            UserDefaults.standard.synchronize()
                            
                            self.performSegue(withIdentifier: "logIn", sender: nil)
                        }
                        else {
                            self.isAccess = false
                            self.displayAlertMessage(message: "Please check your login data")
                        }
                    }
                }
                else{
                    self.displayAlertMessage(message: "Text is not email")
                    return false
                }
            }
        }
        return isAccess
    }
    
    func verifyEmail(email: String) -> Bool{
        let emailRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: textEmail.text!){
            return true
        }
        else{
            return false
        }
    }

}

