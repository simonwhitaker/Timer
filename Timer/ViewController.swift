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
    
    var countdownTimer: CountdownTimer = CountdownTimer(duration: 5 * 60)
    var uiUpdateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.timeLabel?.isEditable = false
        self.timeLabel?.stringValue = countdownTimer.timeRemainingString
        self.updateButtonState()
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
            self.stopUIUpdateTimer()
        case .Initialized:
            self.countdownTimer.start()
            self.startUIUpdateTimer()
        case .Paused:
            self.countdownTimer.resume()
            self.startUIUpdateTimer()
        }
        self.updateButtonState()
    }
    
    @IBAction func handleResetButton(sender: NSControl) {
        self.countdownTimer.reset()
        self.stopUIUpdateTimer()
        self.updateButtonState()
    }
    
    func startUIUpdateTimer() {
        let timer = Timer(timeInterval: 1, repeats: true, block: { (t: Timer) in
            DispatchQueue.main.async {
                self.updateTimeDisplay()
            }
        })
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        timer.fire()
        self.uiUpdateTimer = timer
    }
    
    func stopUIUpdateTimer() {
        self.uiUpdateTimer?.invalidate()
        self.uiUpdateTimer = nil
    }
    
    func updateButtonState() {
        let state = countdownTimer.state
        self.resetButton?.isEnabled = state != .Initialized
        switch state {
        case .Running:
            self.startButton?.title = "Pause"
        case .Initialized:
            self.startButton?.title = "Start"
        case .Paused:
            self.startButton?.title = "Resume"
        }
        self.updateTimeDisplay()
    }
    
    func updateTimeDisplay() {
        self.timeLabel?.stringValue = self.countdownTimer.timeRemainingString
    }
}

