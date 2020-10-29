//
//  AppDelegate.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/24/20.
//

import Cocoa
import SwiftUI
import Preferences


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

   
    var joinMeetingWindow: NSWindow!
    @IBOutlet var preferencesWindow: NSWindow!
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    var calendarHelper : CalendarHelper?
    let sleepDurationSeconds : TimeInterval = 30  // one minute
    let promptInAdvanceSeconds : TimeInterval = 45  // one minute, TODO: make this configurable
    var currentZoomEvent: ZoomEvent?
    
    lazy var preferencesWindowController = PreferencesWindowController(
            preferencePanes: [
                GeneralPreferenceViewController(),
                AdvancedPreferenceViewController()
            ]
        )
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let popoverView = PopoverView()
        
        popover.contentSize = NSSize(width:360, height:200)
        popover.contentViewController = NSHostingController(rootView: popoverView)
        
        statusBar = StatusBarController.init(popover)
        
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        
        NSApp.setActivationPolicy(.accessory)
       
        Timer.scheduledTimer(timeInterval: sleepDurationSeconds, target: self, selector: #selector(checkForEvents), userInfo: nil, repeats: true)
    }
    
    @objc func checkForEvents() {
        print("checking for new events")
        if nil == calendarHelper {
            calendarHelper = CalendarHelper.init()
        }
        calendarHelper?.fetchEventsFromCalendar()
        self.currentZoomEvent = calendarHelper?.getNextZoomEvent()
        if nil == self.currentZoomEvent || nil == self.currentZoomEvent?.startDate {
            print("no zoom event coming up")
            return
        }
        let nowDate: Date = Date()
        let eventDate: Date = self.currentZoomEvent!.startDate
        let secondsRemainingToNextEvent: TimeInterval = eventDate.timeIntervalSince(nowDate)
        
        
        print(String(format: "next event happens at: %@, which is %.1f minutes away", self.currentZoomEvent!.getHumanDateTime(), secondsRemainingToNextEvent/60))
        if (secondsRemainingToNextEvent > 0 && secondsRemainingToNextEvent < promptInAdvanceSeconds) {
            calendarHelper?.markEventAsShown(event: self.currentZoomEvent)
            openJoinMeetingWindow()
        }
    }
    
    @objc func openJoinMeetingWindow() {
        if nil == self.currentZoomEvent {
            print("the zoom event is null!")
            return
        }
        
        print("opening the join meeting prompt")

        NSApplication.shared.keyWindow?.close()
//         Create the window and set the content view.
        if nil == joinMeetingWindow {
            joinMeetingWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            joinMeetingWindow.center()
            joinMeetingWindow.setFrameAutosaveName("Main Window")
        }
        joinMeetingWindow.contentView = NSHostingView(rootView: ContentView(zoomEvent: self.currentZoomEvent!))

        joinMeetingWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        SfxHelper.moo()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(announceEvent), userInfo: nil, repeats: false)
    }
    
    @objc func announceEvent() {
        TtsHelper.announce(text: "your meeting is ready for \(self.currentZoomEvent!.title)")
    }
    
    @objc func openPreferencesWindow() {
        print("opening preferences")
        if nil == preferencesWindow {      // create once !!
            let preferencesView = PreferencesView()
            // Create the preferences window and set content
            preferencesWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            preferencesWindow.center()
            preferencesWindow.setFrameAutosaveName("Preferences")
            preferencesWindow.isReleasedWhenClosed = false
            preferencesWindow.contentView = NSHostingView(rootView: preferencesView)
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    @IBAction
    func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

