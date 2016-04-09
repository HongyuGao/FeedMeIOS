//
//  FeedMe.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 19/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

struct FeedMe {
    
    struct Path {
        static let TEXT_HOST = "http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/"
        static let PICTURE_HOST = "http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/"
    }
    
    struct Variable {
        static var userID: String?
        static var restaurantID: Int?
        static var restaurantName: String?
        static var dishID: Int?
        static var images: [String: UIImage]?
        static var order: Order?
        static var dishes: [Int: Dish]!
        static var selectedDeliveryAddress: Address!
    }
        
}

enum DishType: String {
    case Staple = "Staple"
    case Soup = "Soup"
    case Dessert = "Dessert"
    case Drinks = "Drinks"
    case Others = "Others"
}
