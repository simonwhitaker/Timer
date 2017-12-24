//
//  TouchBarIdentifiers.swift
//  Timer
//
//  Created by Simon Whitaker on 15/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import AppKit

@available(OSX 10.12.2, *)
extension NSTouchBarItem.Identifier {
  static let addTimerItem = NSTouchBarItem.Identifier("org.netcetera.Timer.addTimer")
  static let startPauseItem = NSTouchBarItem.Identifier("org.netcetera.Timer.startPause")
  static let resetItem = NSTouchBarItem.Identifier("org.netcetera.Timer.reset")
}

@available(OSX 10.12.2, *)
extension NSTouchBar.CustomizationIdentifier {
  static let timerBar = NSTouchBar.CustomizationIdentifier("org.netcetera.Timer.timerBar")
}
