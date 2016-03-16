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
    
    var name: String
    var photo: UIImage?
    var openTime: String?
    
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, openTime: String?) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.openTime = openTime
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
    
}
