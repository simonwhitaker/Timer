//
//  TimeIntervalFormatter.swift
//  Timer
//
//  Created by Simon on 07/03/2017.
//  Copyright © 2017 Simon Whitaker. All rights reserved.
//

import Foundation

let separatorCharacter: Character = ":"
let separatorString: String = String(separatorCharacter)

class TimeIntervalFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? NSNumber else {
            return nil
        }
        let seconds = Int(ceil(number.doubleValue))
        let minutes = seconds / 60
        let hours = minutes / 60
        return String(format: "%02d%@%02d%@%02d", arguments: [hours, separatorString, minutes % 60, separatorString, seconds % 60])
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let components = string.components(separatedBy: separatorString)
        if components.count > 3 {
            return false
        }
        
        var sum = 0
        for component in components {
            sum *= 60
            if let val = numberFormatter.number(from: component)?.intValue {
                sum += val
            }
        }
        obj?.pointee = NSNumber(value: sum)
        return true
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "1234567890:").inverted
        if let invalidCharacterRange = partialString.rangeOfCharacter(from: invalidCharacters) {
            return invalidCharacterRange.isEmpty
        }
        
        var string = ""
        for char in partialString.characters.reversed() {
            if char != separatorCharacter {
                string = String(char) + string
                if string.characters.count == 3 || string.characters.count == 6 {
                    string.insert(separatorCharacter, at: string.index(string.startIndex, offsetBy: 1))
                }
            }
        }
        newString?.pointee = string as NSString
        return false
    }
}
