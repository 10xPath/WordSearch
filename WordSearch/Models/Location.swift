//
//  Location.swift
//  WordSearch
//
//  Created by John N on 5/2/20.
//  Copyright © 2020 Examplingo. All rights reserved.
//

import Foundation

struct Location {
    var startLocation: Position!
    var endLocation: Position!
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.endLocation == rhs.endLocation && lhs.startLocation == lhs.startLocation
    }
}
