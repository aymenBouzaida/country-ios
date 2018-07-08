//
//  Country.swift
//  Countries
//
//  Created by AYMEN on 7/7/18.
//  Copyright © 2018 BOUZAIDA. All rights reserved.
//

import UIKit

class CountryOBJ : NSObject {
    
    var name: String?
    var capital: String?
    var flagUrl: String?
    
    // details used only in second view
    var currency : CurrencyOBJ?
    var population : Int?
    var borders : [String] = []
    
}
