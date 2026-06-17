import Foundation

struct FanLevel: Identifiable {
    let id: Int
    let titleKey: String
    let lowerBound: Int
    let upperBound: Int          // exclusive; Int.max for the top tier
}

/// Encapsulates the fan-points levelling curve.
final class FanProgression {
    let levels: [FanLevel]

    init() {
        levels = [
            FanLevel(id: 0, titleKey: "level.0", lowerBound: 0,   upperBound: 60),
            FanLevel(id: 1, titleKey: "level.1", lowerBound: 60,  upperBound: 150),
            FanLevel(id: 2, titleKey: "level.2", lowerBound: 150, upperBound: 300),
            FanLevel(id: 3, titleKey: "level.3", lowerBound: 300, upperBound: 600),
            FanLevel(id: 4, titleKey: "level.4", lowerBound: 600, upperBound: .max),
        ]
    }

    func level(for points: Int) -> FanLevel {
        levels.first { points < $0.upperBound } ?? levels[levels.count - 1]
    }

    func nextThreshold(for points: Int) -> Int {
        let l = level(for: points)
        return l.upperBound == .max ? max(points, l.lowerBound) : l.upperBound
    }

    func progress(for points: Int) -> Double {
        let l = level(for: points)
        if l.upperBound == .max { return 1 }
        let span = Double(l.upperBound - l.lowerBound)
        guard span > 0 else { return 1 }
        return min(1, max(0, Double(points - l.lowerBound) / span))
    }
}
