//
//  ViewController.swift
//  Timer
//
//  Created by Simon on 05/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

enum TimerState {
    case Initialized
    case Running
    case Paused
}

class CountdownTimer {
    var state: TimerState = .Initialized
    var initialDuration: TimeInterval
    var elapsedAtLastPause: TimeInterval
    var startTime: Date?
    
    init(duration: TimeInterval) {
        self.initialDuration = duration
        self.elapsedAtLastPause = 0
        self.state = .Initialized
    }
    
    func start() {
        self.state = .Running
        self.startTime = Date()
    }

    func pause() {
        let temp = self.elapsed
        self.state = .Paused
        self.elapsedAtLastPause = temp
    }
    
    func resume() {
        self.state = .Running
        self.startTime = Date()
    }
    
    func reset() {
        self.state = .Initialized
        self.startTime = nil
        self.elapsedAtLastPause = 0
    }
    
    var elapsed: TimeInterval {
        get {
            switch self.state {
            case .Running:
                guard let startTime = self.startTime else {
                    abort()
                }
                let runtime = Date().timeIntervalSince(startTime)
                return self.elapsedAtLastPause + runtime
            case .Paused:
                return self.elapsedAtLastPause
            case .Initialized:
                return 0
            }
        }
    }
    
    var timeRemainingString: String {
        get {
            let remaining = self.initialDuration - self.elapsed
            let seconds = Int(remaining)
            let minutes = seconds / 60
            let hours = minutes / 60
            return String(format: "%02d:%02d:%02d", arguments: [hours, minutes % 60, seconds % 60])
        }
    }
}

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

