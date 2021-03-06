//
//  CalendarHelper.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/24/20.
//

import EventKit

class CalendarHelper  {

    private let eventStore: EKEventStore
    private var calendarNames: [String]
    private var zoomEvents: [ZoomEvent]
    private var shownEvents: [Int]
    private static let maxEventsRemembered : Int = 5
    
    init(with eventStore: EKEventStore = EKEventStore()) {
        self.eventStore = eventStore
        self.calendarNames = [String]()
        self.zoomEvents = [ZoomEvent]()
        self.shownEvents = [Int]()
   }
    
    func getNextZoomEvent() -> ZoomEvent? {
        // remove any that are in the past
        var sortedEvents = self.zoomEvents.sorted(by: { $0.startDate < $1.startDate })
        // remove any we've already shown
        sortedEvents = sortedEvents.filter() { !alreadyShown(event: $0) }
        
        if sortedEvents.isEmpty {
            return nil
        }
        // now sort
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for e : ZoomEvent in sortedEvents {
            print("event: \(e.title), at \(formatter.string(from: e.startDate))")
        }
        // and return the first in the list, which is the next event by startDate
        return sortedEvents[0]
    }
    
    func fetchEventsFromCalendar() -> Void {
        let status = EKEventStore.authorizationStatus(for: .event)

        switch (status) {
        case .notDetermined:
            requestAccessToCalendar()
        case .authorized:
            self.calendarNames = self.enumerateCalendarNames()
            self.zoomEvents = getNextEvents(calendarNames: self.calendarNames)
            print("found \(self.zoomEvents.count) zoom events")
            for ze:ZoomEvent in self.zoomEvents {
                let eventIdentifier : String = ze.title
                print(eventIdentifier)
            }
            break
        case .restricted, .denied:
            // TODO: prompt user to unblock permissions on calendar or show warning
            print("permissions are: \(status)")
            requestAccessToCalendar()
            break
        @unknown default:
            print("unknown status: \(status)")
        }
    }

    func requestAccessToCalendar() {
        self.eventStore.requestAccess(to: .event) { (accessGranted, error) in
            if accessGranted {
                print("have access")
                self.fetchEventsFromCalendar()
            } else {
                var message : String =  "unknown error getting calendar permissions"
                if (error != nil) {
                    message = error!.localizedDescription
                }
                print(message)
            }
        }
    }

    func enumerateCalendarNames() -> [String] {
        print("building list of calendar names")
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        var calendarList = [String]()

        for calendar:EKCalendar in calendars {
            calendarList.append(calendar.title)
        }
        return calendarList
    }
    
    func getNextEvents(calendarNames: [String]) -> [ZoomEvent] {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        var zoomEvents: [ZoomEvent] = [ZoomEvent]()
        for calendar: EKCalendar in calendars {

            if calendarNames.contains(calendar.title) {

                let selectedCalendar = calendar
                // look at the next 6 months
                let nowDate = Date()
                let endDate = Date().addingTimeInterval(60*60*24*180)
                let predicate = eventStore.predicateForEvents(withStart:nowDate, end: endDate, calendars: [selectedCalendar])
//                print("calendar: \(selectedCalendar)")
                let maybeZoomEvents : [EKEvent] = eventStore.events(matching: predicate)
                for maybeZoomEvent:EKEvent in maybeZoomEvents {
                    if ZoomEvent.eventContainsZoomLink(event: maybeZoomEvent) {
                        if maybeZoomEvent.startDate > nowDate {
                            zoomEvents.append(ZoomEvent.init(event: maybeZoomEvent))
                        } else {
                            print("discarding event: \(maybeZoomEvent.title!) because its start date is in the past")
                        }
                    }
                }
            }
        }
        return zoomEvents
    }
    
    func alreadyShown(event: ZoomEvent) -> Bool {
        return self.shownEvents.contains(event.hashValue)
    }
    
    func markEventAsShown(event: ZoomEvent?) -> Void {
        if nil == event {
            return
        }
        // keep the size of this array small
        self.shownEvents = Array(self.shownEvents.prefix(CalendarHelper.maxEventsRemembered))
        self.shownEvents.append(event!.hashValue)
    }

}
