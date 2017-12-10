//
//  ViewController.swift
//  CircularAnimation
//
//  Created by IJke Botman on 10/12/2017.
//  Copyright © 2017 IJke Botman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Create new shapeLayer
    let shapeLayer = CAShapeLayer()
    var circularPath = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        setupTrackLayer()
        setupShapeLayer()
    
        //Add shapeLayer to view
        view.layer.addSublayer(shapeLayer)
        
        //Add gesture recognizer with action handleTap
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    func setupTrackLayer() {
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
    }
    
    func setupShapeLayer() {
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

