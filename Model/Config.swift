//
//  Config.swift
//  Lux (iOS)
//
//  Created by Jay on 26/09/2020.
//

import Foundation

struct Config {
    static let networks = ["MTN", "Vodafone", "AirtelTigo"]
    static let phoneNumber = Utils.parseConfig().object(forKey: "phone") as! String
    static let meterNumber = "14152852"
    static let voucher = "123456"
    static let amount = "1"
    static let log = ""
    static let isProcessing = false
    static let enersmartURL = "https://enersmart.sperixlabs.org"
    static let pageLoaded = false
}
