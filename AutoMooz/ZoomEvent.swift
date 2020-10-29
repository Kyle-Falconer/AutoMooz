//
//  ZoomEvent.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/25/20.
//

import EventKit
import SwiftSoup

class ZoomEvent: Equatable, Hashable {

    private static let zoomLinkRegex = try! NSRegularExpression(pattern: #"zoom.us/j/([^/"]*)"#,
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
        self.zoomLink = ZoomEvent.zoomUrlFromEvent(event: event)
    }
    
    func getUuid() -> UUID {
        return self.id
    }
    public static func zoomUrlFromEvent(event: EKEvent) -> String? {
        if !event.hasNotes {
            return nil
        }
        return zoomUrlFromEventDescription(desc: event.notes!)
    }
    
    public static func zoomUrlFromEventDescription(desc: String) -> String? {
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(desc)
            let link: Element = try doc.select("a").first()!
            let linkHref: String = try link.attr("href")
            return linkHref
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("error")
        }
        return nil
    }
    
    public static func parseZoomIdFromUrl(desc: String) -> String? {
        let result = desc.groups(for: zoomLinkRegex)
        if result.count > 0 && result[0].count > 0 {
            return result[0][1]
        }
        return nil
    }

    public static func eventContainsZoomLink(event: EKEvent) -> Bool {
        if !event.hasNotes {
            return false
        }
        let desc : String = event.notes!
        let matchGroups = desc.groups(for: zoomLinkRegex)
        if matchGroups.count > 0 {
            return true
        }
        return false
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(originatingCalendarName)
        hasher.combine(zoomLink)
    }
    
    static func == (lhs: ZoomEvent, rhs: ZoomEvent) -> Bool {
        return lhs.getUuid() == rhs.getUuid()
    }
}
