//
//  ViewController.swift
//  CircularLoader
//
//  Created by Tiago Santos on 11/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var progressShapeLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer = createProgressCircle(circularPath, strokeColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), strokeEnd: 1)
        progressShapeLayer = createProgressCircle(circularPath, strokeColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), strokeEnd: 0)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func createProgressCircle(_ circularPath: UIBezierPath, strokeColor: CGColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = strokeEnd
        
        view.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    @objc private func handleTap() {
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        progressShapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
}

