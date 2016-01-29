//
//  WeatherStatusLabel.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/26/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation
import UIKit

/**
 Represents a partial coloration of a `UILabel`.
 */
struct PartialColoration {
    var start: Int
    var length: Int
    var color: UIColor
}

extension UILabel {
    
    func addPartialColor(coloration: PartialColoration) {
        let mutableString = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName: self.font])
        mutableString.addAttribute(NSForegroundColorAttributeName,
            value: coloration.color, range: NSRange(location: coloration.start, length: coloration.length))
        
        self.attributedText = mutableString
    }
}
