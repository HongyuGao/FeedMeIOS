//
//  OrderTableViewController.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 26/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var totalFeeLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FeedMe.Variable.order != nil {
            totalPrice.text = "$" + String(format: "%.2f", FeedMe.Variable.order!.totalPrice)
        } else {
            totalPrice.text = "$" + String(format: "%.2f", 0)
        }
        
        FeedMe.Variable.selectedDeliveryAddress = User().defaultDeliveryAddress!
        FeedMe.Variable.selectedDeliveryAddress.setAsSelected()
        deliveryAddressLabel.text = FeedMe.Variable.selectedDeliveryAddress.toSimpleAddressString()
        updateGrandTotalFee()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.deliveryAddressLabel.text = FeedMe.Variable.selectedDeliveryAddress.toSimpleAddressString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func updateGrandTotalFee() {
        var grandTotalString = deliveryFeeLabel.text!
        grandTotalString.removeAtIndex(grandTotalString.startIndex)
        let grandTotal = FeedMe.Variable.order!.totalPrice + Double(grandTotalString)!
        totalFeeLabel.text = "$" + String(format: "%.2f", grandTotal)
    }
    
    
    @IBAction func newAddressBtnClicked(sender: UIButton) {
        

    }
    
    
    // MARK: - Editing in the table view cell
    @IBAction func increaseBtn(sender: UIButton) {
        let cell = sender.superview!.superview! as! OrderTableViewCell
        FeedMe.Variable.order!.addDish(FeedMe.Variable.order!.id2dish[cell.tag]!, qty: 1)
        cell.dishQtyLabel.text = String(Int(cell.dishQtyLabel.text!)! + 1)
        totalPrice.text = "$" + String(format: "%.2f", FeedMe.Variable.order!.totalPrice)
        updateGrandTotalFee()
    }
    
    @IBAction func decreaseBtn(sender: UIButton) {
        let cell = sender.superview!.superview! as! OrderTableViewCell
        let newQty = Int(cell.dishQtyLabel.text!)! - 1
        FeedMe.Variable.order!.removeDish(cell.tag, qty: 1)
        if newQty == 0 {
            self.tableView.reloadData()
        } else {
            cell.dishQtyLabel.text = String(newQty)
        }
        totalPrice.text = "$" + String(format: "%.2f", FeedMe.Variable.order!.totalPrice)
        updateGrandTotalFee()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedMe.Variable.order!.id2dish.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "OrderTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrderTableViewCell

        // Configure the cell...
        let dish = FeedMe.Variable.order!.dishesList()[indexPath.row]
        cell.dishNameLabel.text = dish.name!
        cell.dishPriceLabel.text = "$" + String(format: "%.2f", Double(dish.price!))
        cell.dishQtyLabel.text = String(FeedMe.Variable.order!.id2count[dish.ID]!)
        
        cell.tag = dish.ID

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

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
