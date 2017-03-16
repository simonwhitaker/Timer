//
//  TouchBarIdentifiers.swift
//  Timer
//
//  Created by Simon Whitaker on 15/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import AppKit

extension NSTouchBarItemIdentifier {
  static let addTimerItem = NSTouchBarItemIdentifier("org.netcetera.Timer.addTimer")
  static let startPauseItem = NSTouchBarItemIdentifier("org.netcetera.Timer.startPause")
  static let resetItem = NSTouchBarItemIdentifier("org.netcetera.Timer.reset")
}

extension NSTouchBarCustomizationIdentifier {
  static let timerBar = NSTouchBarCustomizationIdentifier("org.netcetera.Timer.timerBar")
}
