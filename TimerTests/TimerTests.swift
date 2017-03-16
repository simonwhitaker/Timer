//
//  TimerTests.swift
//  TimerTests
//
//  Created by Simon on 16/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import XCTest

class TimerTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testTimerInit() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let duration = 1.0
    let t = CountdownTimer(duration: duration)
    XCTAssert(abs(t.initialDuration - duration) < DBL_EPSILON, "Newly initialized timer has the wrong duration")
    XCTAssert(t.state == .Initialized, "Newly initialized timer has state other than .Initialized")
  }

  func testStateTransitions() {
    let t = CountdownTimer(duration: 60)
    XCTAssert(t.state == .Initialized, "Newly initialized timer has state other than .Initialized")
    t.start()
    XCTAssert(t.state == .Running, "Running timer has state other than .Running")
    t.pause()
    XCTAssert(t.state == .Paused, "Paused timer has state other than .Paused")
    t.resume()
    XCTAssert(t.state == .Running, "Resumed timer has state other than .Running")
    t.reset()
    XCTAssert(t.state == .Initialized, "Reset timer has state other than .Initialized")
  }
}
