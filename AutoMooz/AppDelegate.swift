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
    
    lazy var preferencesWindowController = PreferencesWindowController(
            preferencePanes: [
                GeneralPreferenceViewController(),
                AdvancedPreferenceViewController()
            ]
        )
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let popoverView = PopoverView()
        
        popover.contentSize = NSSize(width:360, height:360)
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
        let nextZoomEvent = calendarHelper?.getNextZoomEvent()
        if nil == nextZoomEvent || nil == nextZoomEvent?.startDate {
            print("no zoom event coming up")
            return
        }
        let nowDate: Date = Date()
        let eventDate: Date = nextZoomEvent!.startDate
        let secondsRemainingToNextEvent: TimeInterval = eventDate.timeIntervalSince(nowDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, MM/dd/yyyy "
        let eventDateString :String = formatter.string(from: eventDate)
        print(String(format: "next event happens at: %@, which is %.1f minutes away", eventDateString, secondsRemainingToNextEvent/60))
        if (secondsRemainingToNextEvent > 0 && secondsRemainingToNextEvent < promptInAdvanceSeconds) {
            calendarHelper?.markEventAsShown(event: nextZoomEvent)
            openJoinMeetingWindow()
        }
    }
    
    @objc func openJoinMeetingWindow() {
        print("opening the join meeting prompt")
        if nil == joinMeetingWindow {
            let contentView = ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
    //
    //         Create the window and set the content view.
            joinMeetingWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            joinMeetingWindow.center()
            joinMeetingWindow.setFrameAutosaveName("Main Window")
            joinMeetingWindow.contentView = NSHostingView(rootView: contentView)
        }
        joinMeetingWindow.makeKeyAndOrderFront(nil)
//        joinMeetingWindow.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AutoMooz")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
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
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

