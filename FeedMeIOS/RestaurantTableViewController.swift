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
        
        // Initialization:
        FeedMe.Variable.images = [String: UIImage]()
        
        let bgImage = UIImage(named:"background.png")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = bgImage
        
        self.tableView.backgroundView = imageView
        
//        self.view.addSubview(imageView)
//        self.view.sendSubviewToBack(imageView)

        // Load the data:
        loadAllRestaurants(FeedMe.Path.TEXT_HOST + "restaurants/allRestaurant")
        
        // Change the backgroud color of the navigation bar & tab bar:
//        let logoImage = UIImageView(frame: CGRect(x:0, y:0, width: 80, height: 30))
//        logoImage.contentMode = .ScaleAspectFit
//        let nglogo = UIImage(named: "Logo.png")
//        logoImage.image = nglogo
//        self.navigationController?.navigationBar.topItem?.titleView = logoImage
        
        let nav = self.navigationController?.navigationBar
        
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let ngColor = UIColor(red: 203/255, green:41/225, blue: 10/255, alpha: 1)
        nav?.backgroundColor = ngColor
        nav?.barTintColor = ngColor
        self.tabBarController?.tabBar.backgroundColor = ngColor
        self.tabBarController?.tabBar.barTintColor = ngColor
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
                
                if let ID = json[index]["id"] as?Int {
                    let name = json[index]["name"] as?String
                    let description = json[index]["description"] as?String
                    let type = json[index]["type"] as?String
                    let phone = json[index]["phone"] as?String
                    let email = json[index]["email"] as?String
                    let openTimeMorning = json[index]["openTimeMorning"] as?String
                    let openTimeAfternoon = json[index]["openTimeAfternoon"] as?String
                    // let checkin = json[index]["checkin"] as?Bool
                    let checkin = true // MARK: TO BE CHANGED!
                    
                    // load image:
                    let logoName = json[index]["logo"] as?String
                    var image: UIImage?
                
                    var restaurant = Restaurant(ID: ID, name: name, logo: image, description: description, type: type, phone: phone, email: email, openTimeMorning: openTimeMorning, openTimeAfternoon: openTimeAfternoon, checkin: checkin)!

                    if logoName != nil {
                        if let _ = FeedMe.Variable.images![logoName!] {
                            image = FeedMe.Variable.images![logoName!]
                            restaurant.setLogo(image)
                        } else {
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), {
                                self.setImageInBG(&restaurant, logoName: logoName)
                            })
                        }
                    }

                    restaurants += [restaurant]
                }
            }
            
            do_table_refresh()
        } catch _ {
            
        }
    }
    
    func setImageInBG(inout restaurant: Restaurant, logoName: String?) {
        let url = NSURL(string: FeedMe.Path.PICTURE_HOST + "img/logo/" + logoName!)
        let data = NSData(contentsOfURL : url!)
        let image = UIImage(data : data!)
        
        restaurant.logo = image!
        
        // Cache the newly loaded image:
        FeedMe.Variable.images![logoName!] = image
        
        do_table_refresh()
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
        FeedMe.Variable.images?.removeAll()
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
        
        cell.photoImageView.layer.cornerRadius = 10.0
        cell.photoImageView.layer.borderWidth = 2.0
        cell.photoImageView.clipsToBounds = true
        if((indexPath.row)%2 == 0) {
            cell.backgroundColor = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.4)
            cell.photoImageView.layer.borderColor = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.4).CGColor
        } else {
            cell.backgroundColor = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.7)
            cell.photoImageView.layer.borderColor = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.7).CGColor
        }
        
        if restaurant.openTimeMorning != nil && restaurant.openTimeAfternoon != nil {
            cell.timeLabel.text = restaurant.openTimeMorning! + "\n" + restaurant.openTimeAfternoon!
        } else {
            cell.timeLabel.text = ""
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurant = restaurants[indexPath.row]
        FeedMe.Variable.restaurantID = restaurant.ID
        FeedMe.Variable.restaurantName = restaurant.name
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
