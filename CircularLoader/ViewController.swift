//
//  ViewController.swift
//  CircularLoader
//
//  Created by Tiago Santos on 11/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shapeLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
}

