//
//  ViewController.swift
//  CircularLoader
//
//  Created by Tiago Santos on 11/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let downloadUrl = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    var progressShapeLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        createShapeLayers()
        configurePercentageLabel()
    }
    
    fileprivate func configurePercentageLabel() {
        view.addSubview(percentageLabel)
        
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    fileprivate func createShapeLayers() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = createProgressCircle(circularPath, strokeColor: UIColor.clear.cgColor, fillColor: UIColor.pulsatingFillColor.cgColor, strokeEnd: 1)
        trackLayer = createProgressCircle(circularPath, strokeColor: UIColor.trackStrokeColor.cgColor, fillColor: UIColor.backgroundColor.cgColor, strokeEnd: 1)
        progressShapeLayer = createProgressCircle(circularPath, strokeColor: UIColor.outlineStrokeColor.cgColor, fillColor: UIColor.clear.cgColor, strokeEnd: 0)
        
        animatePulsatingLayer()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    fileprivate func createProgressCircle(_ circularPath: UIBezierPath, strokeColor: CGColor, fillColor: CGColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    @objc private func handleTap() {
        print("Attempting to animate stroke")
        beginDownloadingFile()
    }
    
    private func beginDownloadingFile() {
        print("Attempting to download file.")
        
        progressShapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: downloadUrl) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished download file.")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let downloadPercentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(downloadPercentage * 100))%"
            self.progressShapeLayer.strokeEnd = downloadPercentage
        }
        
        print(downloadPercentage)
    }
}

