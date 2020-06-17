//
//  Marker.swift
//  WordSearch
//
//  Created by John N on 5/2/20.
//  Copyright © 2020 Examplingo. All rights reserved.
//

import Foundation
import UIKit

protocol MarkerDelegate: class {
    func didSetEndPosition(mark: Marker)
}

class Marker {
    var startPosition: Position!
    var endPosition: Position! {
        didSet {
            if isHorizontal || isVertical || isDiagonal {
                self.needsLayout = true
                delegate?.didSetEndPosition(mark: self)
            }
        }
    }
    
    weak var delegate: MarkerDelegate?
    
    var needsLayout: Bool = false
    
    var cellSize: CGSize!
    
    var isHorizontal: Bool {
        return startPosition.column == endPosition.column
    }
    
    var isVertical: Bool {
        return startPosition.row == endPosition.row
    }
    
    var isDiagonal: Bool {
        return abs(Int(startPosition.row) - Int(endPosition.row)) == abs(Int(startPosition.column) - Int(endPosition.column))
    }
    
    init(markCellSize: CGSize) {
        self.cellSize = markCellSize
    }
    
    public func startPoint() -> CGPoint {
        return pointForPosition(position: self.startPosition)
    }
    
    public func endPoint() -> CGPoint {
        return pointForPosition(position: self.endPosition)
    }
    
    private func pointForPosition(position: Position) -> CGPoint {
        var point = CGPoint()
        point.x = CGFloat(position.column) * self.cellSize.width + self.cellSize.width/2
        point.y = CGFloat(position.row) * self.cellSize.height + self.cellSize.height/2
        
        return point
    }
}
