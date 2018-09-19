//
//  StringExtension.swift
//
//  Created by León Yannik López Rojas on 4/18/16.
//  Copyright © 2016 liÖn. All rights reserved.
//

import Foundation


extension String {
    
    subscript (i: Int) -> String {
        let elIndex = index(startIndex, offsetBy: i)
        return String(self[elIndex])
    }
    subscript (r: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound + 1)
//        return String(self[Range(start..<end)])
        return String(self[start..<end])
    }
}
