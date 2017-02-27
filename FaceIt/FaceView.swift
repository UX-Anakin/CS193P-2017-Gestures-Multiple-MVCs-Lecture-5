//
//  FaceView.swift
//  FaceIt
//
//  Created by Michel Deiman on 27/02/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable var scale: CGFloat = 0.9
    @IBInspectable var eyesOpen: Bool = true
    @IBInspectable var mouthCurvature: Double = 1.0    // 1.0 is full smile, and -1.0 is full frown
    @IBInspectable var lineWidth: CGFloat = 5.0
    @IBInspectable var color: UIColor = UIColor.blue

    
    private var skullRadius: CGFloat {
        return min(bounds.height, bounds.width) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        let path: UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthOrigin = CGPoint(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset)
        let mouthSize = CGSize(width: mouthWidth, height: mouthHeight)
        let mouthRect = CGRect(origin: mouthOrigin, size: mouthSize)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height

        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: end.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }

    private func pathForSkull() -> UIBezierPath
    {	let path = UIBezierPath(arcCenter: skullCenter,
     	                        radius: skullRadius,
     	                        startAngle: 0.0,
     	                        endAngle: CGFloat.pi * 2,
     	                        clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        color.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: 		CGFloat = 3
        static let SkullRadiusToEyeRadius: 		CGFloat = 10
        static let SkullRadiusToMouthWidth: 	CGFloat = 1
        static let SkullRadiusToMouthHeight: 	CGFloat = 3
        static let SkullRadiusToMouthOffset: 	CGFloat = 3
    }


}
