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
    var name: String?
    var logo: UIImage?
    var description: String?
    var type: String?
    var phone: String?
    var email: String?
    var openTimeMorning: String?
    var openTimeAfternoon: String?
    var checkin: Bool! = false

    
    // MARK: Initialization
    init?(ID: Int, name: String?, logo: UIImage?, description: String?, type: String?, phone: String?, email: String?, openTimeMorning: String?, openTimeAfternoon: String?, checkin: Bool) {
        // Initialize stored properties.
        self.ID = ID
        self.name = name
        self.logo = logo
        self.description = description
        self.type = type
        self.phone = phone
        self.email = email
        self.openTimeMorning = openTimeMorning
        self.openTimeAfternoon = openTimeAfternoon
        self.checkin = checkin
    }
    
    func setLogo(image: UIImage?) {
        self.logo = image
    }
    
}
