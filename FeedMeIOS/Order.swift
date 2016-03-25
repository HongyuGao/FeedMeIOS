//
//  Order.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 25/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import Foundation

class Order {
    
    // MARK: Properties
    var userID: String?
    var restaurantID: Int?
    var orderTime: String?
    var deliveryAddress: String?
    var phoneNumber: String?
    
    // total number of items:
    var itemsCount: Int = 0
    
    // total number of prices:
    var totalPrice: Double = 0
    
    // information for all dishes in the shopping cart:
    // list of all dishes:
    var dishes: [Dish]
    // count of every dish: Dish ID -> Dish Count:
    var dish2count: Dictionary<Int, Int>
    
    
    // MARK: Initialization
    init(userID: String?, restaurantID: Int, orderTime: String, deliveryAddress: String?, phoneNumber: String?, itemsCount: Int = 0, totalPrice: Double = 0, dishes: [Dish], dish2count: Dictionary<Int, Int>) {
        self.userID = userID
        self.restaurantID = restaurantID
        self.orderTime = orderTime
        self.deliveryAddress = deliveryAddress
        self.phoneNumber = phoneNumber
        self.itemsCount = itemsCount
        self.totalPrice = totalPrice
        self.dishes = dishes
        self.dish2count = dish2count
    }

    
    // MARK: Methods
    // Set the timestamp when order is conformed.
    func setTime() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        self.orderTime = dateFormatter.stringFromDate(NSDate())
    }
    
    // Set the delivery address.
    func setDeliverAddress(deliveryAddress: String) {
        self.deliveryAddress = deliveryAddress
    }
    
    // Set the contact phone number.
    func setPhoneNumber(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    // Change and set items count.
    func changeItemsCount(increase: Bool, qty: Int) {
        self.itemsCount = increase ? self.itemsCount + qty : self.itemsCount - qty
    }
    
    // Change and set total price.
    func changeTotalPrice(increase: Bool, amount: Double) {
        self.totalPrice = increase ? self.totalPrice + amount : self.totalPrice - amount
    }
    
    // Add dish to the order.
    func addDish(dish: Dish, qty: Int = 1) {

    }
    
    // Remove dish from the order.
    func removeDish(dishID: Int) {
    
    }

}