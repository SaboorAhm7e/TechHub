//
//  NavigationRoute.swift
//  TechHub
//
//  Created by saboor on 29/11/2025.
//

import SwiftUI

enum NavigationRute : Hashable {
    case showDetail(DeviceModel)
    case addDevice(UUID)
}
