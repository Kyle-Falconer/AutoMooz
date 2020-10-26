//
//  AdvancedPreferenceViewController.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/25/20.
//

import Cocoa
import Preferences

final class AdvancedPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.advanced
    let preferencePaneTitle = "Advanced"
    let toolbarItemIcon = NSImage(named: NSImage.advancedName)!

    override var nibName: NSNib.Name? { "AdvancedPreferenceViewController" }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup stuff here
        print("viewDidLoad for Advanced Preferences view controller")
    }
}
