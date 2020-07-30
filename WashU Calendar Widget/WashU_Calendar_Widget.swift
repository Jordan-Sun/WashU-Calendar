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
import CoreData

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
    
    var managedObjectContext : NSManagedObjectContext
    
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        // Initialize fetch request
//        let request = Event.fetchRequest() as NSFetchRequest<Event>
//
//        // Apply predicate if date is not nil
//        let calendar = Calendar.current
//        let dayStart = calendar.startOfDay(for: Date()) as NSDate
//        guard let dayEnd = calendar.date(byAdding: DateComponents(day: 1), to: dayStart as Date) as NSDate? else {
//            fatalError("Fail to compute the end of day for date: \(dayStart).")
//        }
//        let predicate = NSPredicate(format: "(start >= %@) AND (start <= %@)", dayStart, dayEnd)
//        request.predicate = predicate
//
//        // Apply sort descriptors
//        let sort = NSSortDescriptor(key: #keyPath(Event.start), ascending: true)
//        request.sortDescriptors = [sort]
//
//        // Try to perform fetch request
//        var eventFetchedResultController: NSFetchedResultsController<Event>!
//        do {
//            eventFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//            try eventFetchedResultController.performFetch()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
        
        let widgetEvent = WidgetEvent(eventName: "Nothing to do", eventInterval: DateInterval(start: Date(), end: Date()), eventLocation: "Take a break", eventColor: .systemTeal)
        let entry = SimpleEntry(date: Date(), event: widgetEvent, configuration: configuration)
        
//        // Generate a timeline.
//        guard let event = eventFetchedResultController.fetchedObjects?.first else {
//            let widgetEvent = WidgetEvent(eventName: "Nothing to do", eventInterval: DateInterval(start: Date(), end: Date()), eventLocation: "Take a break", eventColor: .systemTeal)
//            let entry = SimpleEntry(date: Date(), event: widgetEvent, configuration: configuration)
//
//            completion(entry)
//            return
//        }
//
//        let widgetEvent = WidgetEvent(eventName: event.name ?? "Unknown Event", eventInterval: DateInterval(start: event.start!, end: event.end!), eventLocation: event.location, eventColor: event.color as! UIColor)
//        let entry = SimpleEntry(date: Date(), event: widgetEvent, configuration: configuration)
        
        completion(entry)
    }
    
    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
//        // Initialize fetch request
//        let request = Event.fetchRequest() as NSFetchRequest<Event>
//
//        // Apply predicate if date is not nil
//        let calendar = Calendar.current
//        let dayStart = calendar.startOfDay(for: Date()) as NSDate
//        guard let dayEnd = calendar.date(byAdding: DateComponents(day: 1), to: dayStart as Date) as NSDate? else {
//            fatalError("Fail to compute the end of day for date: \(dayStart).")
//        }
//        let predicate = NSPredicate(format: "(start >= %@) AND (start <= %@)", dayStart, dayEnd)
//        request.predicate = predicate
//
//        // Apply sort descriptors
//        let sort = NSSortDescriptor(key: #keyPath(Event.start), ascending: true)
//        request.sortDescriptors = [sort]
//
//        // Try to perform fetch request
//        var eventFetchedResultController: NSFetchedResultsController<Event>!
//        do {
//            eventFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//            try eventFetchedResultController.performFetch()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline.
        let widgetEvent = WidgetEvent(eventName: "Nothing to do", eventInterval: DateInterval(start: Date(), end: Date()), eventLocation: "Take a break", eventColor: .systemTeal)
        let entry = SimpleEntry(date: Date(), event: widgetEvent, configuration: configuration)
        let calendar = Calendar.current
        let timeline = Timeline(entries: [entry], policy: .after(calendar.startOfDay(for: Date().addingTimeInterval(24.0 * 60.0 * 60.0))))
        completion(timeline)
//        guard let events = eventFetchedResultController.fetchedObjects else {
//            let widgetEvent = WidgetEvent(eventName: "Nothing to do", eventInterval: DateInterval(start: Date(), end: Date()), eventLocation: "Take a break", eventColor: .systemTeal)
//            let entry = SimpleEntry(date: Date(), event: widgetEvent, configuration: configuration)
//
//            let timeline = Timeline(entries: [entry], policy: .after(calendar.startOfDay(for: Date().addingTimeInterval(24.0 * 60.0 * 60.0))))
//            completion(timeline)
//            return
//        }
//        guard !events.isEmpty else {
//            let widgetEvent = WidgetEvent(eventName: "Nothing to do", eventInterval: DateInterval(start: Date(), end: Date()), eventLocation: "Take a break", eventColor: .systemTeal)
//            let entry = SimpleEntry(date: Date(), event: widgetEvent, configuration: configuration)
//
//            let timeline = Timeline(entries: [entry], policy: .after(calendar.startOfDay(for: Date().addingTimeInterval(24.0 * 60.0 * 60.0))))
//            completion(timeline)
//            return
//        }
//        var lastEnd = Date()
//
//        for event in events {
//            let widgetEvent = WidgetEvent(eventName: event.name ?? "Unknown Event", eventInterval: DateInterval(start: event.start!, end: event.end!), eventLocation: event.location, eventColor: event.color as! UIColor)
//            let entry = SimpleEntry(date: lastEnd, event: widgetEvent, configuration: configuration)
//            lastEnd = widgetEvent.eventInterval.end
//            entries.append(entry)
//        }
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }
    
    func placeholder(with: Context) -> SimpleEntry {
        let previewEvent = WidgetEvent.previewData
        return SimpleEntry(date: Date(), event: previewEvent, configuration: ConfigurationIntent())
    }
    
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let event: WidgetEvent
    public let configuration: ConfigurationIntent
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct WashU_Calendar_WidgetEntryView : View {
    
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            DayView(entry: entry)
            Spacer()
            Text(entry.event.eventInterval.start, style: .time)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .frame(width: 40.0, height: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
            EventView(event: entry.event)
            
        }
        .padding(.vertical, 8.0)
        
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
        .padding(.vertical, 4.0)
        .frame(width: /*@START_MENU_TOKEN@*/140.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/40.0/*@END_MENU_TOKEN@*/)
        .background(Color(event.eventColor))
        .cornerRadius(12)
        
    }
    
}

@main
struct WashU_Calendar_Widget: Widget {
    private let kind: String = "WashU_Calendar_Widget"
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "WashU_Calendar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(managedObjectContext: persistentContainer.viewContext)) { entry in
            WashU_Calendar_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Track Event")
        .description("Keep track of one event.")
        .supportedFamilies([.systemSmall])
    }
}

struct WashU_Calendar_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WashU_Calendar_WidgetEntryView(entry: SimpleEntry(date: Date(), event: WidgetEvent.previewData, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WashU_Calendar_WidgetEntryView(entry: SimpleEntry(date: Date(), event: WidgetEvent.previewData, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .redacted(reason: .placeholder)
    }
}
