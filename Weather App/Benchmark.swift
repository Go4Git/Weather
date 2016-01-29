//
//  Benchmark.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/29/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation
import CoreFoundation

class BenchmarkTimer {
  
  let startTime:CFAbsoluteTime
  var endTime:CFAbsoluteTime?
  
  init() {
    startTime = CFAbsoluteTimeGetCurrent()
  }
  
  func stop() -> CFAbsoluteTime {
    endTime = CFAbsoluteTimeGetCurrent()
    
    return duration!
  }
  
  var duration:CFAbsoluteTime? {
    if let endTime = endTime {
      return endTime - startTime
    } else {
      return nil
    }
  }
}
