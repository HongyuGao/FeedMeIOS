//
//  RestaurantTableViewController.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 16/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    // MARK: Properties
    var restaurants = [Restaurant]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the data.
        loadAllRestaurants(FeedMe.Path.TEXT_HOST + "restaurants/allRestaurant")
        
        let ngColor = UIColor(red: 203/255, green:41/225, blue: 10/255, alpha: 1)
        //        self.navigationController?.navigationBar.barTintColor = bgColor
        UINavigationBar.appearance().barTintColor = ngColor
        UITabBar.appearance().barTintColor = ngColor
        
        // Change the backgroud color of the tab bar:
        // self.tabBarController?.tabBar.backgroundColor = UIColor.redColor()
        // self.tabBarController?.tabBar.barTintColor = UIColor.redColor()
    }
    
    func loadAllRestaurants(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setShopInfo(myData!)
            })
        }
        
        task.resume()
    }
    
    func setShopInfo(shopData: NSData) {
        let json: Array<AnyObject>
        do {
            json = try NSJSONSerialization.JSONObjectWithData(shopData, options: .AllowFragments) as! Array<AnyObject>
            for index in 0...json.count-1 {
                
                if let name = json[index]["name"] as?String {
                    let ID = json[index]["id"] as?Int
                    
                    // load image:
                    let logoName = json[index]["logo"] as?String
                    var image: UIImage?
                    if logoName != nil {
                        let url = NSURL(string: FeedMe.Path.PICTURE_HOST + "img/logo/" + logoName!)
                        let data = NSData(contentsOfURL : url!)
                        image = UIImage(data : data!)
                    }
                    
                    let openTimeMorning = json[index]["openTimeMorning"] as?String
                    let openTimeAfternoon = json[index]["openTimeAfternoon"] as?String
                    let restaurant = Restaurant(ID: ID!, name: name, logo: image, openTimeMorning: openTimeMorning, openTimeAfternoon: openTimeAfternoon)!
    
                    restaurants += [restaurant]
                }
            }
            
            do_table_refresh()
        } catch _ {
            
        }
    }
    
    
     func loadImageFromUrl(url: String, inout image: UIImage){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    image = UIImage(data: data)!
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RestaurantTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        cell.photoImageView.image = restaurant.logo
        
        if restaurant.openTimeMorning != nil && restaurant.openTimeAfternoon != nil {
            cell.timeLabel.text = restaurant.openTimeMorning! + ", " + restaurant.openTimeAfternoon!
        } else {
            cell.timeLabel.text = ""
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurant = restaurants[indexPath.row]
        FeedMe.Variable.restaurantID = restaurant.ID
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
