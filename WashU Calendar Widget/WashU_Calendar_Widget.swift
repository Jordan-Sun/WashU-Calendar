//
//  WashU_Calendar_Widget.swift
//  WashU Calendar Widget
//
//  Created by Zhuoran Sun on 2020/7/29.
//  Copyright © 2020 washu. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct WidgetEvent {
    let eventName: String
    let eventInterval: DateInterval
    let eventLocation: String?
    let eventColor: UIColor
}

extension WidgetEvent {
    static let previewData = WidgetEvent(eventName: "Preview Event", eventInterval: DateInterval(start: Date().advanced(by: 10.0 * 60.0 + 6.0), duration: 60.0 * 60.0), eventLocation: "Preview Location", eventColor: .systemPink)
}

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct WashU_Calendar_WidgetEntryView : View {
    
    var entry: Provider.Entry
    var event: WidgetEvent
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            DayView(entry: entry)
            Text("in 10 minutes")
                .font(.caption)
            EventView(event: event)
            
        }
        .padding(.all, 0.0)
        
    }
}

struct DayView: View {
    
    var entry: Provider.Entry
    
    let weekdayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        return dateFormatter
    }()
    
    let dayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        return dateFormatter
    }()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(entry.date, formatter: self.weekdayFormatter)
                .font(.headline)
                .minimumScaleFactor(0.6)
                .foregroundColor(.red)
            Text(entry.date, formatter: self.dayFormatter)
                .font(.title)
                .minimumScaleFactor(0.6)
            
        }
    }
}

struct EventView: View {
    
    var event: WidgetEvent
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(event.eventName)
                .font(.body)
                .minimumScaleFactor(0.6)
            Text(event.eventLocation ?? "")
                .font(.caption)
                .minimumScaleFactor(0.6)
        }
        .padding(.all, 4.0)
        
        .background(Color(event.eventColor))
        .cornerRadius(12)
        
    }
    
}

@main
struct WashU_Calendar_Widget: Widget {
    private let kind: String = "WashU_Calendar_Widget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            WashU_Calendar_WidgetEntryView(entry: entry, event: WidgetEvent.previewData)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WashU_Calendar_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WashU_Calendar_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()), event: WidgetEvent.previewData)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
