//
//  DataModel.swift
//  MysqlTest
//
//  Created by César Manuel on 19/01/23.
//

import Foundation

protocol DataModelProtocol: AnyObject{
    func itemsDownloaded(items: NSArray)
    
}

class DataModel: NSObject {
    
    weak var delegate: DataModelProtocol!
    
    let urlPath = "https://ioslocations.000webhostapp.com/select.php"
    
    func downloadItems(){
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){ (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }
            else{
                print("Data downloaded")
                //Parse JSON:
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let location = LocationModel()
            
            if let name = jsonElement["Name"] as? String,
               let address = jsonElement["Address"] as? String,
               let latitude = jsonElement["Latitude"] as? String,
               let longitude = jsonElement["Longitude"] as? String
            {
                location.name = name
                location.address = address
                location.latitude = latitude
                location.longitude = longitude
            }
            
            locations.add(location)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: locations)
        })
    }
}
