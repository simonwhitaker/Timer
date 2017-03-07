//
//  TimeIntervalFormatter.swift
//  Timer
//
//  Created by Simon on 07/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Foundation

class TimeIntervalFormatter: NumberFormatter {
    let separator = ":"
    
    override func string(from number: NSNumber) -> String? {
        let seconds = Int(ceil(number.doubleValue))
        let minutes = seconds / 60
        let hours = minutes / 60
        return String(format: "%02d%@%02d%@ %02d", arguments: [hours, separator, minutes % 60, separator, seconds % 60])
    }
    
    override func number(from string: String) -> NSNumber? {
        let components = string.components(separatedBy: separator)
        assert(components.count == 3, "Expected 3 components, got \(components.count)")
        
        var sum = 0
        for component in components {
            sum *= 60
            if let val = super.number(from: component)?.intValue {
                sum += val
            }
        }
        return NSNumber(value: sum)
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "1234567890:").inverted
        if let invalidCharacterRange = partialString.rangeOfCharacter(from: invalidCharacters) {
            return invalidCharacterRange.isEmpty
        }
        
        var string = ""
        for char in partialString.characters.reversed() {
            if char != ":" {
                string = String(char) + string
                if string.characters.count == 3 || string.characters.count == 6 {
                    string.insert(":", at: string.index(string.startIndex, offsetBy: 1))
                }
            }
        }
        newString?.pointee = string as NSString
        return false
    }
}
