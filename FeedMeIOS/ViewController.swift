//
//  ViewController.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 3/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
        
        // Retrieve the list of all online shops' IDs:
        var shopIDs = Set<String>()
        shopIDs.insert("1")
        shopIDs.insert("17")
        shopIDs.insert("18")
        
        
        for shopID in shopIDs {
            getShopData("http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/restaurants/query/?id="+shopID)
        }
//        getShopData("http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/restaurants/query/?id=1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveOnlineShops() {
        // TODO!
        // retrieve data from databases:
        
    }
    
    func getShopData(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(myData!)
            })
        }
        
        task.resume()
    }
    
    func setLabels(weatherData: NSData) {
        let json: NSDictionary
        do {
            json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .AllowFragments) as! NSDictionary
            print("json")
            print(json)
            
//            if let name = json["name"] as? String {
//                cityNameLabel.text = name
//            }
//            
//            if let phone = json["phone"] as? String {
//                cityTempLabel.text = phone
//            }
            
            //            if let main = json["main"] as? NSDictionary {
            //                if let temp = main["temp"] as? Double {
            //                    print(temp)
            //                    cityTempLabel.text = String(format: "%.1f", temp)
            //                }
            //            }
        } catch _ {
            
        }
    }


}

