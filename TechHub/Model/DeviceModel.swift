//
//  DeviceModel.swift
//  TechHub
//
//  Created by saboor on 23/11/2025.
//

import SwiftUI

struct DeviceModel : Identifiable,Hashable, Codable, Equatable {
    
    let id : String
    let name : String
    var icon : String {
        if name.lowercased().contains("iphone") {
            return "iphone"
        } else if name.lowercased().contains("macbook") {
            return "macbook"
        } else if name.lowercased().contains("airpods") {
            return "airpods"
        } else if name.lowercased().contains("beats") {
            return "beats.studiobuds"
        } else if name.lowercased().contains("watch") {
            return "applewatch"
        } else if name.lowercased().contains("ipad") {
            return "ipad.landscape"
        } else {
            return "questionmark"
        }
    }
}
