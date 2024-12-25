import SwiftUI

enum TimerStyle: String, CaseIterable, Identifiable, Codable {
    case circular
    case minimal
    case classic
    case modern
    case digital
    case analog
    case wave
    case gradient
    case segments
    case retro
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .circular: return "Circular"
        case .minimal: return "Minimal"
        case .classic: return "Classic"
        case .modern: return "Modern"
        case .digital: return "Digital"
        case .analog: return "Analog"
        case .wave: return "Wave"
        case .gradient: return "Gradient"
        case .segments: return "Segments"
        case .retro: return "Retro"
        }
    }
    
    var icon: String {
        switch self {
        case .circular: return "circle.circle"
        case .minimal: return "circle.slash"
        case .classic: return "clock"
        case .modern: return "clock.circle"
        case .digital: return "square.stack"
        case .analog: return "clock.fill"
        case .wave: return "waveform.path"
        case .gradient: return "circle.hexagongrid"
        case .segments: return "chart.pie"
        case .retro: return "tv"
        }
    }
} 