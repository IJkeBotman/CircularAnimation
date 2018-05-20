//
//  ViewController.swift
//  CircularAnimation
//
//  Created by IJke Botman on 10/12/2017.
//  Copyright © 2017 IJke Botman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    let urlString = "https://upload.wikimedia.org/wikipedia/commons/e/e6/Clocktower_Panorama_20080622_20mb.jpg"
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var circularPath = UIBezierPath()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObserver()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setupTrackLayer()
        setupShapeLayer()
        view.layer.addSublayer(shapeLayer)
        setupPercentageLayer()
        
        //Add gesture recognizer with action handleTap
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        beginDownloadingFile()
    }
    
    //Make sure the pulsating layer starts up again when the app returns to foreground.
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    //Add observer for when the app enters foreground.
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    //Download file with URLSessionConfiguration to monitor the download progress.
    private func beginDownloadingFile() {
        print("Attempting to download file.")
        
        shapeLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
    }
    
    //Delegate function that monitors bytes written and expected bytes to write. Set the percentage label and strokeEnd of the shapeLayer to the percentage downloaded.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
    }
    
    //Required protocol function
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file.")
    }
    
    //Animate the circle with CABasicAnimation, set fillMode and make sure the stroke is not removed after completion.
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    //Add the percentageLabel to the center of the screen
    fileprivate func setupPercentageLayer() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    //Shape that is underneath the animating stroke. Shape that is pulsating out from the track layer.
    func setupTrackLayer() {
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
    
        animatePulsatingLayer()
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
    }
    
    //Setup and rotate shapeLayer to make the stroke start at the top of the shape.
    func setupShapeLayer() {
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
    }
    
    //Setup circle shape with bezier path, strokeColor, fillColor, lineWidth, lineCap, and position.
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineWidth = 20
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        
        return layer
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "Pulsing")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

