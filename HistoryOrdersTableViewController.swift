//
//  HistoryOrdersTableViewController.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 3/04/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class HistoryOrdersTableViewController: UITableViewController {

    var historyOrders: HistoryOrders?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if loadData() {
            print("Order history is not mepty!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load data source
    
    func loadData() -> Bool {
        var currentOrders:[Order]? = [Order]()
        
        let curOrder1 = Order(userID: FeedMe.Variable.userID, restaurantID: 1)
        curOrder1.totalPrice = 100
        curOrder1.setTime()
        currentOrders = currentOrders! + [curOrder1]
        
        var pastOrders:[Order]? = [Order]()
        let pastOrder1 = Order(userID: FeedMe.Variable.userID, restaurantID: 1)
        pastOrder1.totalPrice = 200
        pastOrder1.setTime()
        pastOrders = pastOrders! + [pastOrder1]
        
        historyOrders = HistoryOrders(currentOrders: currentOrders, pastOrders: pastOrders)

        return true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return historyOrders!.getCurrentOrders()!.count
        case 1:
            return historyOrders!.getPastOrders()!.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryOrdersTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryOrdersTableViewCell

        // Configure the cell...
        var order: Order?
        
        switch indexPath.section {
        case 0:
            order = historyOrders!.getCurrentOrders()![indexPath.row]
            cell.OrderStateLabel.text = "Being Cooked"
        case 1:
            order = historyOrders!.getPastOrders()![indexPath.row]
            cell.OrderStateLabel.text = "Finished"
        default:
            break
        }
        
        cell.GrandTotalLabel.text = String(order!.totalPrice)
        cell.OrderDateLabel.text = order!.orderTime!
        

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Current Orders (\(historyOrders!.getCurrentOrders()!.count))"
        case 1:
            return "History Orders (\(historyOrders!.getPastOrders()!.count))"
        default:
            return ""
        }
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
