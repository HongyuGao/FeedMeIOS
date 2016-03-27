//
//  DishTableViewController.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 19/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class DishTableViewController: UITableViewController {
    
    @IBOutlet weak var restaurantPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantPhoto.image = UIImage(named: "no_image_available.png")
        
        FeedMe.Variable.images = [String: UIImage]()
        FeedMe.Variable.order = Order(userID: FeedMe.Variable.userID, restaurantID: FeedMe.Variable.restaurantID!)
        FeedMe.Variable.dishes = [Dish]()
        
        let bgImage = UIImage(named: "background.png")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = bgImage
        self.tableView.backgroundView = imageView
        navigationItem.title = FeedMe.Variable.restaurantName
        
        loadAllDishes(FeedMe.Path.TEXT_HOST + "dishes/query/?shopId=" + String(FeedMe.Variable.restaurantID!))
    }
    
    @IBAction func backToRestList(sender: UIBarButtonItem) {
        if FeedMe.Variable.order!.isEmptyOrder() {
           self.navigationController?.popViewControllerAnimated(true)
        } else {
            let alert = UIAlertController(title: "Tips", message: "Change to another restaurant will empty your current shopping cart, are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (ACTION) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func loadAllDishes(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setDishInfo(myData!)
            })
        }
        
        task.resume()
    }
    
    func setDishInfo(dishData: NSData) {
        let json: Array<AnyObject>
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(dishData, options: .AllowFragments) as! Array<AnyObject>
            for index in 0...json.count-1 {
                
                if let ID = json[index]["id"] as?Int {
                    let shopID = json[index]["shopId"] as?Int
                    let type = json[index]["type"] as?String
                    let name = json[index]["name"] as?String
                    let description = json[index]["description"] as?String
                    
                    let ingredient = json[index]["ingredient"] as?String
                    let price = json[index]["price"] as?Int
                    let discount = json[index]["discount"] as?Int
                    let flavor = json[index]["flavor"] as?String
                    let sold = json[index]["sold"] as?Int
                    
                    var photo: UIImage?
                    
                    var dish = Dish(ID: ID, shopID: shopID, type: type, name: name, description: description, photo: photo, ingredient: ingredient, price: price, discount: discount, flavor: flavor, sold: sold)!
                    
                    // load image:
                    let photoName = json[index]["photo"] as?String
                    if photoName != nil {
                        if let _ = FeedMe.Variable.images![photoName!] {
                            photo = FeedMe.Variable.images![photoName!]
                            dish.setPhoto(photo)
                        } else {
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), {
                                self.setImageInBG(&dish, photoName: photoName)
                            })
                        }
                    }

                    FeedMe.Variable.dishes = FeedMe.Variable.dishes! + [dish]
                }
            }
            
            do_table_refresh()
            
        } catch _ {
            
        }
    }
    
    func setImageInBG(inout dish: Dish, photoName: String?) {
        let url = NSURL(string: FeedMe.Path.PICTURE_HOST + "img/photo/" + photoName!)
        let data = NSData(contentsOfURL : url!)
        let photo = UIImage(data : data!)
        
        dish.photo = photo!
        
        // Cache the newly loaded image:
        FeedMe.Variable.images![photoName!] = photo
        
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
        return FeedMe.Variable.dishes!.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DishTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DishTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let dish = FeedMe.Variable.dishes![indexPath.row]
        
        
        cell.nameLabel.text = dish.name!
        cell.photoImageView.image = dish.photo
        
        cell.photoImageView.layer.cornerRadius = 10.0
        cell.photoImageView.layer.borderWidth = 0.0
        cell.photoImageView.clipsToBounds = true
//        cell.photoImageView.layer.borderColor = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 1).CGColor
       

        
        cell.addToShoppingCart.tag = indexPath.row
        cell.addToShoppingCart.layer.borderWidth = 0
        cell.addToShoppingCart.layer.cornerRadius = 6.0
//        cell.addToShoppingCart.layer.borderColor = UIColor(red: 194/225, green: 45/255, blue: 36/255, alpha: 1).CGColor

        
        cell.photoImageView.layer.cornerRadius = 10.0
        cell.photoImageView.layer.borderWidth = 0.0
        cell.photoImageView.clipsToBounds = true
        cell.backgroundColor = UIColor(red: 255/225, green: 255/255, blue: 255/255, alpha: 0.6)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dish = FeedMe.Variable.dishes![indexPath.row]
        FeedMe.Variable.dishID = dish.ID
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
