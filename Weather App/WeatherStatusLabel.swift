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
  
    /**
      Adds a `PartialColoration` to a `UILabel`.

      - Parameter coloration: The partial coloration to add.
    */
    func addPartialColor(colorations: PartialColoration...) {
        let mutableString = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName: self.font])
        
        for (var i = 0; i < colorations.count; i++) {
            let coloration = colorations[i];
            mutableString.addAttribute(NSForegroundColorAttributeName,
                value: coloration.color, range: NSRange(location: coloration.start, length: coloration.length))
        }
        //mutableString.addAttribute(NSForegroundColorAttributeName,
           // value: coloration.color, range: NSRange(location: coloration.start, length: coloration.length))
        
        self.attributedText = mutableString
    }
}
