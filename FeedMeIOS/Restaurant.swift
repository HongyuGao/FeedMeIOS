//
//  Restaurant.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 16/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class Restaurant {
    // MARK: Properties
    var ID: Int
    var name: String
    var logo: UIImage?
    var openTimeMorning: String?
    var openTimeAfternoon: String?
    
    
    // MARK: Initialization
    init?(ID: Int, name: String, logo: UIImage?, openTimeMorning: String?, openTimeAfternoon: String?) {
        // Initialize stored properties.
        self.ID = ID
        self.name = name
        self.logo = logo
        self.openTimeMorning = openTimeMorning
        self.openTimeAfternoon = openTimeAfternoon
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
}
