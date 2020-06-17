//
//  MarkerView.swift
//  WordSearch
//
//  Created by John N on 5/2/20.
//  Copyright © 2020 Examplingo. All rights reserved.
//

import UIKit

protocol MarkerViewDelegate: class {
    func touchesBeganAtPoint(point: CGPoint)
    func touchesMovedAtPoint(point: CGPoint)
    func touchesEndedAtPoint(point: CGPoint)
    func touchesCanceled()
}

class MarkerView: UIImageView {
    weak var delegate: MarkerViewDelegate?

    private var marks: [Marker] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
             return
        }
        
        let touch = firstTouch
        let point = touch.location(in: self)
        delegate?.touchesBeganAtPoint(point: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }
        
        let touch = firstTouch
        let point = touch.location(in: self)
        delegate?.touchesMovedAtPoint(point: point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
              return
         }
        
        let touch = firstTouch
        let point = touch.location(in: self)
        delegate?.touchesEndedAtPoint(point: point)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesCanceled()
    }
    
    public func addMark(mark:Marker) {
        mark.delegate = self
        marks.append(mark)
        drawMark(mark: mark)
    }
    
    public func clear() {
        image = nil
        marks.removeAll()
    }
    
    private func drawMark(mark:Marker) {
        UIGraphicsBeginImageContext(frame.size)
        image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: mark.startPoint().x, y: mark.startPoint().y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: mark.endPoint().x, y: mark.endPoint().y))
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(29)
        UIGraphicsGetCurrentContext()?.setStrokeColor(UIColor.black.cgColor)
        UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.plusDarker)
        UIGraphicsGetCurrentContext()?.strokePath()
        image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 0.3
        UIGraphicsEndImageContext()
    }
}

extension MarkerView: MarkerDelegate {
    func didSetEndPosition(mark: Marker) {
        image = nil
        drawMark(mark: mark)
        mark.needsLayout = false
    }
}
