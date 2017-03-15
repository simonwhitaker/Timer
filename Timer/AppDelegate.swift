//
//  AppDelegate.swift
//  Timer
//
//  Created by Simon on 05/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if #available(OSX 10.12.2, *) {
      NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
