//
//  SecondController.swift
//  FirstApp
//
//  Created by César Manuel on 06/01/23.
//

import UIKit

class SecondController: UIViewController {
    
    
    @IBOutlet weak var label1: UILabel!
    
    
    @IBOutlet weak var label2: UILabel!
    
    
    @IBOutlet weak var label3: UILabel!
    
    
    @IBOutlet weak var buttonPressMe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func pressedButton(_ sender: Any) {
        
        label1.text = "Hello World!"
        label2.text = "I'm label2"
        label3.text = "I'm label3"
        
    }
    
    
}
