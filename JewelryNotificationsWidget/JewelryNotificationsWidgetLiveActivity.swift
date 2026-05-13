//
//  JewelryNotificationsWidgetLiveActivity.swift
//  JewelryNotificationsWidget
//
//  Created by Arsenii Dvornichenko on 25.05.2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct JewelryNotificationsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct JewelryNotificationsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: JewelryNotificationsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension JewelryNotificationsWidgetAttributes {
    fileprivate static var preview: JewelryNotificationsWidgetAttributes {
        JewelryNotificationsWidgetAttributes(name: "World")
    }
}

extension JewelryNotificationsWidgetAttributes.ContentState {
    fileprivate static var smiley: JewelryNotificationsWidgetAttributes.ContentState {
        JewelryNotificationsWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: JewelryNotificationsWidgetAttributes.ContentState {
         JewelryNotificationsWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: JewelryNotificationsWidgetAttributes.preview) {
   JewelryNotificationsWidgetLiveActivity()
} contentStates: {
    JewelryNotificationsWidgetAttributes.ContentState.smiley
    JewelryNotificationsWidgetAttributes.ContentState.starEyes
}
