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
    
    var trackLayer: CAShapeLayer!
    
    var progressShapeLayersList = [CAShapeLayer]()
    var pulsatingLayersList = [CAShapeLayer]()
    var downloadCompletedLabelsList = [UILabel]()
    var downloadPercentageLabelsList = [UILabel]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        setupNotificationObservers()
        createShapeLayers(outlineStrokecolor: UIColor.outlineRedStrokeColor, trackStrokeColor: UIColor.trackRedStrokeColor, pulsatingFillColor: UIColor.pulsatingRedFillColor, yPositionVariant: -160)
        createShapeLayers(outlineStrokecolor: UIColor.outlineBlueStrokeColor, trackStrokeColor: UIColor.trackBlueStrokeColor, pulsatingFillColor: UIColor.pulsatingBlueFillColor, yPositionVariant: 160)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func handleEnterForeground() {
        animatePulsatingLayers()
    }
    
    fileprivate func createLabel(forLabelText labelText: String, andLabelFontSize fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        return label
    }
    
    fileprivate func setupLabels(yPositionVariant: CGFloat) {
        
        let percentageLabel = createLabel(forLabelText: "Start", andLabelFontSize: 32)
        let completedLabel = createLabel(forLabelText: "Completed", andLabelFontSize: 16)
        
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = CGPoint(x: view.center.x, y: view.center.y + yPositionVariant)
        
        completedLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        completedLabel.center = CGPoint(x: percentageLabel.center.x, y: percentageLabel.center.y + 30)
        completedLabel.isHidden = true
        
        downloadPercentageLabelsList.append(percentageLabel)
        downloadCompletedLabelsList.append(completedLabel)
        
        view.addSubview(percentageLabel)
        view.addSubview(completedLabel)
    }
    
    fileprivate func createShapeLayers(outlineStrokecolor: UIColor, trackStrokeColor: UIColor, pulsatingFillColor: UIColor, yPositionVariant: CGFloat) {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let pulsatingLayer = createProgressCircle(circularPath, strokeColor: UIColor.clear.cgColor, fillColor: pulsatingFillColor.cgColor, strokeEnd: 1, yPositionVariant: yPositionVariant)
        trackLayer = createProgressCircle(circularPath, strokeColor: trackStrokeColor.cgColor, fillColor: UIColor.backgroundColor.cgColor, strokeEnd: 1, yPositionVariant: yPositionVariant)
        let progressShapeLayer = createProgressCircle(circularPath, strokeColor: outlineStrokecolor.cgColor, fillColor: UIColor.clear.cgColor, strokeEnd: 0, yPositionVariant: yPositionVariant)
        
        progressShapeLayersList.append(progressShapeLayer)
        pulsatingLayersList.append(pulsatingLayer)
        
        setupLabels(yPositionVariant: yPositionVariant)
        
        animatePulsatingLayers()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func animatePulsatingLayers() {
        for pulsatingLayer in pulsatingLayersList {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            
            animation.toValue = 1.5
            animation.duration = 0.8
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            
            pulsatingLayer.add(animation, forKey: "pulsing")
        }
    }
    
    fileprivate func createProgressCircle(_ circularPath: UIBezierPath, strokeColor: CGColor, fillColor: CGColor, strokeEnd: CGFloat, yPositionVariant: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.position = CGPoint(x: view.center.x, y: view.center.y + yPositionVariant)
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
        
        for progressShapeLayer in progressShapeLayersList {
             progressShapeLayer.strokeEnd = 0
        }
        
        for downloadCompletedLabel in downloadCompletedLabelsList {
            downloadCompletedLabel.isHidden = true
        }
        
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
            
            for downloadPercentageLabel in self.downloadPercentageLabelsList {
                downloadPercentageLabel.text = "\(Int(downloadPercentage * 100))%"
            }
            
            for progressShapeLayer in self.progressShapeLayersList {
                progressShapeLayer.strokeEnd = downloadPercentage
            }
            
            if downloadPercentage == 1 {
                for completedLabel in self.downloadCompletedLabelsList {
                    completedLabel.isHidden = false
                }
            }
        }
    }
}

