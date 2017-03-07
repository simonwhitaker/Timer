//
//  CountdownTimer.swift
//  Timer
//
//  Created by Simon on 06/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

class CountdownTimer {
    enum CountdownTimerState {
        case Initialized
        case Running
        case Paused
        case Complete
    }
    
    var state: CountdownTimerState = .Initialized
    var initialDuration: TimeInterval
    var tickTimerInterval: TimeInterval = 1.0
    var tickCallback: ((CountdownTimer) -> Void)?
    var didCompleteCallback: ((CountdownTimer) -> Void)?
    
    
    private var elapsedAtLastPause: TimeInterval
    private var startTime: Date?
    private var tickTimer: Timer?

    init(duration: TimeInterval) {
        self.initialDuration = duration
        self.elapsedAtLastPause = 0
        self.state = .Initialized
    }
    
    func start() {
        self.state = .Running
        self.startTime = Date()
        self.startTickTimer()
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
    
    private func startTickTimer() {
        let timer = Timer(timeInterval: self.tickTimerInterval, repeats: true, block: { (t: Timer) in
            if let callback = self.tickCallback {
                callback(self)
            }
            if self.elapsed >= self.initialDuration {
                self.state = .Complete
                if let completeCallback = self.didCompleteCallback {
                    completeCallback(self)
                }
                self.stopTickTimer()
            }
        })
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        timer.fire()
        self.tickTimer = timer
    }
    
    private func stopTickTimer() {
        self.tickTimer?.invalidate()
        self.tickTimer = nil
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
            case .Complete:
                return self.initialDuration
            }
        }
    }
    
    var timeRemainingString: String {
        get {
            let remaining = self.initialDuration - self.elapsed
            let seconds = Int(ceil(remaining))
            let minutes = seconds / 60
            let hours = minutes / 60
            return String(format: "%02d:%02d:%02d", arguments: [hours, minutes % 60, seconds % 60])
        }
    }
}
