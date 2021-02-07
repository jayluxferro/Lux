//
//  Utils.swift
//  Lux (iOS)
//
//  Created by Jay on 07/02/2021.
//

import Foundation

struct Utils {
    
    static func parseConfig() -> NSDictionary {
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }
}
