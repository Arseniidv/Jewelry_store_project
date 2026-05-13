//
//  JewelryNotificationsWidgetBundle.swift
//  JewelryNotificationsWidget
//
//  Created by Arsenii Dvornichenko on 25.05.2026.
//

import WidgetKit
import SwiftUI

@main
struct JewelryNotificationsWidgetBundle: WidgetBundle {
    var body: some Widget {
        JewelryNotificationsWidget()
        JewelryNotificationsWidgetControl()
        JewelryNotificationsWidgetLiveActivity()
    }
}
