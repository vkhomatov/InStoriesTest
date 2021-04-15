//
//  Animator.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 09.04.2021.
//

import Foundation
import UIKit

class Animator {
    
    private var mainView = UIView(frame: .zero)
    private var controller = UIViewController()
    private var whiteView = UIView(frame: .zero)
    private var whiteViewCopy = UIView(frame: .zero)
    private var mainPath = UIBezierPath()
    private var borderWidth: CGFloat = 0
    private var linesCount: Int = 15
    private var lineWidth: CGFloat = 0
    private var startLines = [CALayer]()
    private var linesHeightSizeCoeff: CGFloat = 1
    private var maskLayer = CAShapeLayer()
    private var header: CGFloat = 0
    public var progress: Bool = false
    
    
    init(view: UIView? = nil, header: CGFloat = 0) {
        if let view = view {
            self.mainView = view
            self.header = header
        }
    }
    
    public func startAnimation() {
        progress = true
        setWhiteView()
        setLines()
        setPath()
        runStartAnimationPath { [weak self] in
            guard let self = self else { return }
            self.startLinesAnimation(velocity: -1, activeView: self.whiteView)  { [weak self] in
                guard let self = self else { return }
                self.whiteViewCopy.isHidden = false
                self.whiteView.isHidden = true
                if let subLayers = self.whiteView.layer.sublayers {
                    subLayers.forEach { $0.removeAllAnimations() }
                }
            }
            
            self.setWhiteViewCopy()
            self.startLinesAnimation(sizeCoeff: 4/7, velocity: 10.5, autoreverse: true, repeatCount: .infinity, activeView: self.whiteViewCopy, coeff: -71.5, completion: nil)
        }
    }
    
    public func stopAnimation() {
        if let subLayers = whiteViewCopy.layer.sublayers {
            subLayers.forEach { $0.removeAllAnimations() }
        }
        maskLayer.removeAllAnimations()
        whiteView.layer.mask = nil
        whiteView.removeFromSuperview()
        UIView.transition(with: self.mainView, duration: 0.5, options: .transitionFlipFromRight, animations: { [weak self] in
            guard let self = self else { return }
            self.whiteViewCopy.removeFromSuperview()
        }, completion: { _ in self.progress = false } )
    }
    
    private func setWhiteView() {
        whiteView = UIView(frame: CGRect(x: mainView.frame.minX, y: mainView.frame.minY+header, width: mainView.frame.width, height: mainView.frame.height - header))
        whiteView.clipsToBounds = true
        whiteView.backgroundColor = .white
        whiteView.layer.compositingFilter = "screenBlendMode"
        mainView.addSubview(whiteView)
    }
    
    private func setWhiteViewCopy() {
        whiteViewCopy = UIView(frame: CGRect(x: mainView.frame.minX, y: mainView.frame.minY+header, width: mainView.frame.width, height: mainView.frame.height - header))
        whiteView.clipsToBounds = true
        whiteViewCopy.bounds = CGRect(x: borderWidth, y: borderWidth, width: whiteViewCopy.frame.width-borderWidth*2, height: whiteViewCopy.frame.height-borderWidth*2)
        whiteViewCopy.backgroundColor = .white
        whiteViewCopy.layer.compositingFilter = "screenBlendMode"
        whiteViewCopy.isHidden = true
        mainView.addSubview(whiteViewCopy)
    }
    
    private func setLines() {
        linesHeightSizeCoeff = mainView.bounds.height/926
        borderWidth = mainView.bounds.width/CGFloat(linesCount)/2
        lineWidth = (mainView.bounds.width-borderWidth*2)/CGFloat(linesCount)/2
    }
    
    private func setPath() {
        mainPath = UIBezierPath(rect: CGRect(x: mainView.frame.minX, y: mainView.frame.minY, width: mainView.frame.width, height: mainView.frame.height - header))
        mainPath.append(UIBezierPath(rect: CGRect(x: mainView.frame.minX, y: mainView.frame.minY, width: mainView.frame.width, height: mainView.frame.height - header)))
        maskLayer.path = mainPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        whiteView.layer.mask = maskLayer
    }
    
    
    // создает массив слоев(линий) с нужными размерами и свойствами
    private func setLineSizes(sizeCoeff: CGFloat, middleLineCoeff: CGFloat) -> [CALayer] {
        
        // 15, 30, 125, 245, 310, 400, 310, 320, 245, 345, 210, 145, 115, 55, 30   //:5
        var lines = [CALayer]()
        var lineHeight: CGFloat = 0
        
        for lineNum in 1...linesCount {
            let line = CALayer()
            
            if lineNum < 3  {
                lineHeight = CGFloat(lineNum * 3) * 5 * sizeCoeff
            } else if lineNum < 4  {
                lineHeight = CGFloat(lineNum * 3 * lineNum) * 5 * sizeCoeff
            } else if lineNum <= 5 {
                lineHeight = CGFloat(lineNum * 3 * 4) * 5 * sizeCoeff
            } else if lineNum < 7 {
                lineHeight = CGFloat(lineNum * 3 * (3 + (lineNum+1) % 2)) * 5 * sizeCoeff
            } else if lineNum <= 7 {
                lineHeight = CGFloat((lineNum+2) * 3 * 2) * 5 * sizeCoeff
            } else if lineNum == 8 {
                lineHeight = CGFloat((lineNum) * 3 * 2) * 5 * middleLineCoeff
            } else if lineNum <= 9 {
                lineHeight = CGFloat((linesCount - lineNum) * 3 * 2) * 5 * sizeCoeff
            } else if lineNum <= 10 {
                lineHeight = CGFloat((linesCount - lineNum + 2 ) * 3 * 3) * 5 * sizeCoeff
            }  else if lineNum <= 14 {
                lineHeight = CGFloat((linesCount - lineNum) * 4 * 2) * 5 * sizeCoeff
            } else if lineNum <= 15 {
                lineHeight = CGFloat((lineNum % 2) * 2) * 2 * 5 * sizeCoeff
            }
            
            line.frame = CGRect(x: CGFloat(CGFloat(lineNum-1)*lineWidth*2 + lineWidth/2 + borderWidth), y: 0, width: lineWidth, height: lineHeight*linesHeightSizeCoeff)
            line.backgroundColor = UIColor.black.cgColor
            line.position.y = whiteView.center.y - header
            line.compositingFilter = "subtractBlendMode"
            lines.append(line)
            
        }
        
        return lines
        
    }
    
    private func runStartAnimationPath(completion: @escaping (() -> Void))  {
        
        let midlleLineHeight = setLineSizes(sizeCoeff: 1, middleLineCoeff: 1)[linesCount/2].frame.height
        
        
        let mainFinishPath = UIBezierPath(rect: CGRect(x: borderWidth, y: borderWidth, width: whiteView.frame.width-borderWidth*2, height: whiteView.frame.height-borderWidth*2))
        
        let centrPath = UIBezierPath(rect: CGRect(x: mainView.frame.midX-lineWidth/2, y: mainView.frame.midY-midlleLineHeight*4/7/2-header/2, width: lineWidth, height: 4/7*midlleLineHeight))
        
        mainFinishPath.append(centrPath)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = mainFinishPath.cgPath
        pathAnimation.duration = 2
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pathAnimation.speed = 4
        pathAnimation.fillMode = .both
        pathAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock(completion)
        mainPath = mainFinishPath
        maskLayer.add(pathAnimation, forKey: nil)
        
    }
    
    
    private func lineAnimation(velocity: CGFloat, delay: CGFloat, oldFrame: CGRect, newFrame: CGRect, autoreverse: Bool = false, repeatCount: Float = 0, coeff: CGFloat = 0,  completion: (() -> Void)?) -> CASpringAnimation {
        
        let anim = CASpringAnimation(keyPath: "bounds")
        
        anim.fromValue = oldFrame
        anim.toValue = newFrame
        anim.autoreverses = autoreverse
        anim.repeatCount = repeatCount
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.damping = 0.6
        anim.mass = 0.3
        anim.initialVelocity = velocity
        anim.stiffness = 8
        anim.duration = anim.settlingDuration
        anim.duration = 1.9
        anim.beginTime = CACurrentMediaTime() + Double(delay+coeff)/100
        
        CATransaction.setCompletionBlock(completion)
        return anim
        
    }
    
    private func startLinesAnimation(sizeCoeff: CGFloat = 0, middleLineCoeff: CGFloat = 4/7, velocity: CGFloat = 0, autoreverse: Bool = false, repeatCount: Float = 0, activeView: UIView, coeff: CGFloat = 0, completion: (() -> Void)?) {
        
        startLines = setLineSizes(sizeCoeff: sizeCoeff, middleLineCoeff: middleLineCoeff)
        
        for lineNum in 0..<startLines.count {
            activeView.layer.addSublayer(startLines[lineNum])
        }
        
        let newLines = setLineSizes(sizeCoeff: 1, middleLineCoeff: 1)
        
        for lineNum in 0..<startLines.count/2 {
            startLines[lineNum].add(lineAnimation(velocity: velocity, delay: CGFloat((startLines.count/2-lineNum)*10), oldFrame: startLines[lineNum].bounds, newFrame:  newLines[lineNum].bounds, autoreverse: autoreverse, repeatCount: repeatCount, coeff: coeff, completion: nil), forKey: nil)
        }
        
        for lineNum in startLines.count/2..<startLines.count {
            startLines[lineNum].add(lineAnimation(velocity: velocity, delay: CGFloat((lineNum-startLines.count/2)*10), oldFrame: startLines[lineNum].bounds, newFrame: newLines[lineNum].bounds, autoreverse: autoreverse, repeatCount: repeatCount, coeff: coeff, completion: { CATransaction.setCompletionBlock(completion) }), forKey: nil)
        }
        
    }
    
}



