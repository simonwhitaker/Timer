//
//  SystemSoundTests.swift
//  Timer
//
//  Created by Simon on 29/05/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import XCTest

class SystemSoundTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testAvailableSounds() {
    let availableSounds = SystemSound.availableSounds()
    XCTAssertNotNil(availableSounds)
    XCTAssert(availableSounds.count > 0)
  }
}
