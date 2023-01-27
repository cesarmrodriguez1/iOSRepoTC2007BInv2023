//
//  ViewController.swift
//  MysqlTest
//
//  Created by César Manuel on 19/01/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol {

    @IBOutlet weak var myTableView: UITableView!
    
    var locationItems: NSArray = NSArray()
    var selectedLocation: LocationModel = LocationModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.downloadItems()
    }
    
    func itemsDownloaded(items: NSArray) {
        locationItems = items
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : String = "itemCell"
        let myCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        let item: LocationModel = locationItems[indexPath.row] as! LocationModel
        
        myCell.textLabel!.text = item.address
        
        return myCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue"{
            let item = sender as? UITableViewCell
            let indexPath = myTableView.indexPath(for: item!)
            let mapVC = segue.destination as! MapViewController
            
            mapVC.selectedLocation = locationItems[(indexPath?.row)!] as? LocationModel
            
            
            
        }
        
        
    }
    


}

