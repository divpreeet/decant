//
//  Bottle.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import Foundation

struct Bottle: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var path: URL
    var created: Date
    
    //wine conf
    var wineVersion: String
    var architecture: String
}
