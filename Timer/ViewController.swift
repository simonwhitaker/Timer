//
//  ViewController.swift
//  Timer
//
//  Created by Simon on 05/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var timeLabel: NSTextField?
    @IBOutlet var startButton: NSButton?
    @IBOutlet var resetButton: NSButton?
    
    var countdownTimer = CountdownTimer(duration: 5 * 60)
    var uiUpdateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.timeLabel?.isEditable = false
        self.timeLabel?.stringValue = countdownTimer.timeRemainingString
        self.updateUI()
        
        self.countdownTimer.tickCallback = {(timer: CountdownTimer) -> Void in
            self.updateUI()
        }
        
        self.countdownTimer.didCompleteCallback = {(timer: CountdownTimer) -> Void in
            self.updateUI()
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func handleStartButton(sender: NSControl) {
        switch self.countdownTimer.state {
        case .Running:
            self.countdownTimer.pause()
        case .Initialized:
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
        case .Initialized, .Complete:
            self.startButton?.title = "Start"
        case .Paused:
            self.startButton?.title = "Resume"
        }

        self.timeLabel?.stringValue = self.countdownTimer.timeRemainingString
        self.timeLabel?.textColor = state == .Complete ? NSColor.gray : NSColor.black
    }
}

