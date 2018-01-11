//
//  UIColorExtension.swift
//  CircularLoader
//
//  Created by Tiago Santos on 11/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    
    static let outlineRedStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackRedStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingRedFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
    static let outlineBlueStrokeColor = UIColor.rgb(r: 41, g: 123, b: 224)
    static let trackBlueStrokeColor = UIColor.rgb(r: 38, g: 92, b: 125)
    static let pulsatingBlueFillColor = UIColor.rgb(r: 54, g: 104, b: 162)
}
