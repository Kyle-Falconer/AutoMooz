//
//  GeneralPreferenceViewController.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/25/20.
//

import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!

    override var nibName: NSNib.Name? { "GeneralPreferenceViewController" }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
        print("viewDidLoad for General Preferences view controller")
    }
}
