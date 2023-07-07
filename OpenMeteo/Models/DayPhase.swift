//
//  DayPhase.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 07.07.2023.
//

import Foundation

enum DayPhase {
    case day
    case night
    case sunrise
    case sunset
    
    func obtainClearSkyType() -> SkyType {
        switch self {
        case .day:     return .day
        case .night:   return .night
        case .sunrise: return .sunrise
        case .sunset:  return .sunset
        }
    }
}
