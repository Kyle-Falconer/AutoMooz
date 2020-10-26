//
//  ZoomEvent.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/25/20.
//

import EventKit

class ZoomEvent: Equatable {

    private let zoomLinkRegex = try! NSRegularExpression(pattern: #"zoom.us/j/(.*$)"#,
                                                 options: .caseInsensitive)
    private var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var originatingCalendarName: String
    var zoomLink: String?
    var zoomId: String?
    var hasBeenShown: Bool
    
    
    public init(title: String, startDate: Date, endDate: Date, originatingCalendarName: String, zoomLink: String) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.originatingCalendarName = originatingCalendarName
        self.zoomLink = zoomLink
        self.hasBeenShown = false
    }
    
    public init(event: EKEvent) {
        self.id = UUID()
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.originatingCalendarName = event.calendar.title
        self.hasBeenShown = false
        self.zoomUrlFromEvent(event: event)
    }
    
    func getUuid() -> UUID {
        return self.id
    }
    
    func zoomUrlFromEvent(event: EKEvent) -> Void {
        if !event.hasNotes {
            return
        }
        let desc : String = event.notes!
        parseZoomUrl(desc: desc)
    }
    
    func parseZoomUrl(desc: String) -> Void {
        let result = desc.groups(for: zoomLinkRegex)
        if result.count > 0 {
            self.zoomId = result[0][0]
        }
    }

    
    func getHumanTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self.startDate)
    }
    
    func getHumanDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, MM/dd/yyyy "
        return formatter.string(from: self.startDate)
    }
    
    static func == (lhs: ZoomEvent, rhs: ZoomEvent) -> Bool {
        return lhs.getUuid() == rhs.getUuid()
    }
}
