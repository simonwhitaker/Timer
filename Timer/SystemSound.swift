//
//  SystemSound.swift
//  Timer
//
//  Created by Simon on 29/05/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Cocoa

class SystemSound: NSObject {
  static var _availableSounds: [String]? = nil

  static func availableSounds() -> [String] {
    if _availableSounds == nil {
      let fm = FileManager()
      let systemLibraryURLs = fm.urls(for: .libraryDirectory, in: .systemDomainMask)
      var sounds = [String]()
      for systemLibraryURL in systemLibraryURLs {
        let soundDirectoryURL = systemLibraryURL.appendingPathComponent("Sounds")

        do {
          let soundURLs = try fm.contentsOfDirectory(at: soundDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
          for soundURL in soundURLs {
            let name = soundURL.deletingPathExtension().lastPathComponent
            sounds.append(name)
          }
        } catch {
          return []
        }
      }
      _availableSounds = sounds.sorted()
    }
    return _availableSounds!
  }
}
