//
//  TimerViewController.swift
//  Timer
//
//  Created by Simon on 05/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController, NSTextFieldDelegate, NSTouchBarDelegate {
  @IBOutlet var timeLabel: NSTextField?
  @IBOutlet var startButton: NSButton?
  @IBOutlet var resetButton: NSButton?
  var uiUpdateTimer: Timer?

  let countdownTimer = CountdownTimer(duration: 5 * 60)

  let touchBarStartButton: NSButton

  required init?(coder: NSCoder) {
    if #available(OSX 10.12.2, *) {
      touchBarStartButton = NSButton(image: NSImage(named: NSImageNameTouchBarPlayTemplate)!, target:nil, action:nil)
    } else {
      touchBarStartButton = NSButton()
    }
    super.init(coder: coder)
    touchBarStartButton.target = self
    touchBarStartButton.action = #selector(self.handleStartButton)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.timeLabel?.delegate = self
    self.timeLabel?.formatter = TimeIntervalFormatter()

    self.countdownTimer.tickCallback = {(timer: CountdownTimer) -> Void in self.updateUI() }
    self.countdownTimer.didCompleteCallback = {(timer: CountdownTimer) -> Void in self.updateUI() }

    self.updateUI()
  }

  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    if let f = timeLabel?.font {
      timeLabel?.font = NSFont(name: f.fontName, size: view.frame.width / 6)
    }
  }

  @IBAction func handleStartButton(sender: NSControl) {
    switch self.countdownTimer.state {
    case .Running:
      self.countdownTimer.pause()
    case .Initialized:
      guard let duration = self.timeLabel?.objectValue as? NSNumber else {
        return
      }
      self.countdownTimer.initialDuration = duration.doubleValue
      self.countdownTimer.start()
    case .Paused:
      self.countdownTimer.resume()
    case .Complete:
      break
    }
    self.updateUI()
  }

  @IBAction func handleResetButton(sender: NSControl) {
    self.countdownTimer.reset()
    self.view.window?.makeFirstResponder(self.startButton)
    self.updateUI()
  }

  func updateUI() {
    let state = countdownTimer.state
    self.resetButton?.isEnabled = state != .Initialized
    self.startButton?.isEnabled = state != .Complete

    switch state {
    case .Running:
      self.startButton?.title = "Pause"
      if #available(OSX 10.12.2, *) {
        self.touchBarStartButton.image = NSImage(named: NSImageNameTouchBarPauseTemplate)
      }
    case .Initialized, .Complete:
      self.startButton?.title = "Start"
      if #available(OSX 10.12.2, *) {
        self.touchBarStartButton.image = NSImage(named: NSImageNameTouchBarPlayTemplate)
      }
    case .Paused:
      self.startButton?.title = "Resume"
      if #available(OSX 10.12.2, *) {
        self.touchBarStartButton.image = NSImage(named: NSImageNameTouchBarPlayTemplate)
      }
    }

    self.timeLabel?.isEditable = state == .Initialized
    self.timeLabel?.doubleValue = self.countdownTimer.timeRemaining
    self.timeLabel?.textColor = state == .Complete ? NSColor.gray : NSColor.black
  }

  @available(OSX 10.12.2, *)
  override func makeTouchBar() -> NSTouchBar? {
    let mainBar = NSTouchBar()
    mainBar.delegate = self
    mainBar.customizationIdentifier = .timerBar
    mainBar.defaultItemIdentifiers = [.addTimerItem, .startPauseItem, .resetItem]
    mainBar.customizationAllowedItemIdentifiers = [.addTimerItem, .startPauseItem, .resetItem]

    return mainBar
  }

  @available(OSX 10.12.2, *)
  func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
    let customViewItem = NSCustomTouchBarItem(identifier: identifier)
    switch identifier {
    case NSTouchBarItemIdentifier.startPauseItem:
      customViewItem.view = self.touchBarStartButton
      customViewItem.customizationLabel = "Start button"
      return customViewItem
    case NSTouchBarItemIdentifier.resetItem:
      customViewItem.view = NSButton(image: NSImage(named: NSImageNameTouchBarRefreshTemplate)!, target: self, action: #selector(self.handleResetButton))
      customViewItem.customizationLabel = "Reset button"
      return customViewItem
    case NSTouchBarItemIdentifier.addTimerItem:
      customViewItem.view = NSButton(image: NSImage(named: NSImageNameTouchBarAddTemplate)!, target: self, action: #selector(self.handleAddTimerButton))
      customViewItem.customizationLabel = "Add Timer button"
      return customViewItem
    default:
      return nil
    }
  }

  func handleAddTimerButton() {
    NSDocumentController.shared().newDocument(self)
  }
}
