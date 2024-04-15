//
//  Address.swift
//  Rental
//
//  Created by Rafael Turse on 2024-03-13.
//

import Foundation

class Address {
    
    var street: String = ""
    var postalCode: String = ""
    var city: String = ""
    
    init(street: String, postalCode: String, city: String) {
        self.street = street
        self.postalCode = postalCode
        self.city = city
    }
}
