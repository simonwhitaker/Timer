//
//  TimerWindowController.swift
//  Timer
//
//  Created by Simon on 06/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

class TimerWindowController: NSWindowController {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    shouldCascadeWindows = true
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    if let window = window,
      let screen = window.screen
    {
      let offsetFromLeftOfScreen:CGFloat = 20
      let offsetFromTopOfScreen: CGFloat = 20
      let screenRect = screen.visibleFrame
      let newOriginY = screenRect.maxY - window.frame.height - offsetFromTopOfScreen
      window.setFrameOrigin(NSPoint(x: offsetFromLeftOfScreen, y: newOriginY))
    }
  }

  static var windowNumber = 1

  override func windowTitle(forDocumentDisplayName displayName: String) -> String {
    let result = "Timer \(TimerWindowController.windowNumber)"
    TimerWindowController.windowNumber += 1
    return result
  }
}
