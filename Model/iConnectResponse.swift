//
//  iConnect.swift
//  Lux (iOS)
//
//  Created by Jay on 14/04/2021.
//

import Foundation

struct iConnectResponse: Decodable {
    let url: String
    let port: Double
    let createdAt: String
    let updatedAt: String
    let id: String
}
