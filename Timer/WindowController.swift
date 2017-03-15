//
//  WindowController.swift
//  Timer
//
//  Created by Simon on 06/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSTouchBarDelegate {
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


  @available(OSX 10.12.2, *)
  override func makeTouchBar() -> NSTouchBar? {
    let mainBar = NSTouchBar()
    mainBar.delegate = self
    mainBar.customizationIdentifier = .timerBar
    mainBar.defaultItemIdentifiers = [.addTimerItem]
    mainBar.customizationAllowedItemIdentifiers = [.addTimerItem]

    return mainBar
  }

  @available(OSX 10.12.2, *)
  func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
    switch identifier {
    case NSTouchBarItemIdentifier.addTimerItem:
      let customViewItem = NSCustomTouchBarItem(identifier: identifier)
      customViewItem.view = NSButton(title: "Add Timer", target: self, action: #selector(self.handleAddTimerButton))
      return customViewItem
    default:
      return nil
    }
  }

  func handleAddTimerButton() {
    NSDocumentController.shared().newDocument(self)
  }

}
