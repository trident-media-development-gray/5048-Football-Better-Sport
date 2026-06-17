import SwiftUI
import Combine

enum MatchPhase { case pregame, running, paused, finished }

/// What the generator decides happened in a given minute (language-neutral).
struct GeneratedEvent {
    let kind: EventKind
    let attackingHome: Bool
}

/// Snapshot the generator reasons about.
struct MatchSnapshot {
    let minute: Int
    let homeScore: Int
    let awayScore: Int
    let homeStrength: Double
    let awayStrength: Double
}

protocol MatchEventGenerating {
    func event(for snapshot: MatchSnapshot) -> GeneratedEvent?
}

/// Weighted-random event model. Goals are rare; chances/saves/cards more common.
struct ProbabilisticEventGenerator: MatchEventGenerating {
    func event(for s: MatchSnapshot) -> GeneratedEvent? {
        let total = s.homeStrength + s.awayStrength
        let attackingHome = Double.random(in: 0...1) < (total > 0 ? s.homeStrength / total : 0.5)
        switch Double.random(in: 0...1) {
        case ..<0.05:  return GeneratedEvent(kind: .goal,   attackingHome: attackingHome)
        case ..<0.13:  return GeneratedEvent(kind: .chance, attackingHome: attackingHome)
        case ..<0.19:  return GeneratedEvent(kind: .save,   attackingHome: attackingHome)
        case ..<0.225: return GeneratedEvent(kind: .yellow, attackingHome: attackingHome)
        default:       return nil
        }
    }
}

/// Drives the interactive live-match simulation. Pluggable event generator and
/// clock interval make it testable and configurable.
final class MatchSimulator: ObservableObject {
    @Published private(set) var minute = 0
    @Published private(set) var homeScore = 0
    @Published private(set) var awayScore = 0
    @Published private(set) var events: [MatchEvent] = []
    @Published private(set) var phase: MatchPhase = .pregame

    let home: Team
    let away: Team
    private let homeStrength: Double
    private let awayStrength: Double
    private let generator: MatchEventGenerating
    private let tickInterval: TimeInterval
    private var timer: Timer?

    init(home: Team,
         away: Team,
         homeStrength: Double = 0.56,
         awayStrength: Double = 0.52,
         generator: MatchEventGenerating = ProbabilisticEventGenerator(),
         tickInterval: TimeInterval = 0.28) {
        self.home = home
        self.away = away
        self.homeStrength = homeStrength
        self.awayStrength = awayStrength
        self.generator = generator
        self.tickInterval = tickInterval
    }

    var isRunning: Bool { phase == .running }
    var isFinished: Bool { phase == .finished }

    func toggle() {
        switch phase {
        case .finished: reset()
        case .running:  pause()
        default:        start()
        }
    }

    private func start() {
        if phase == .pregame {
            emit(.kickoff, side: .neutral, team: nil)
            Haptics.tap(.medium)
        }
        phase = .running
        timer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func pause() {
        phase = .paused
        timer?.invalidate(); timer = nil
    }

    func reset() {
        timer?.invalidate(); timer = nil
        minute = 0; homeScore = 0; awayScore = 0; events = []; phase = .pregame
    }

    private func tick() {
        guard minute < 90 else { finish(); return }
        minute += 1

        if let ev = generator.event(for: snapshot()) {
            let side: Side = ev.attackingHome ? .home : .away
            let team = ev.attackingHome ? home : away
            if ev.kind == .goal {
                if ev.attackingHome { homeScore += 1 } else { awayScore += 1 }
                emit(.goal, side: side, team: team)
                Haptics.goal()
            } else {
                emit(ev.kind, side: side, team: team)
            }
        }

        if minute == 45 { emit(.kickoff, side: .neutral, team: nil) }
        if minute >= 90 { finish() }
    }

    private func snapshot() -> MatchSnapshot {
        MatchSnapshot(minute: minute, homeScore: homeScore, awayScore: awayScore,
                      homeStrength: homeStrength, awayStrength: awayStrength)
    }

    private func emit(_ kind: EventKind, side: Side, team: Team?) {
        let event = MatchEvent(minute: minute, kind: kind, side: side, team: team,
                               homeTeam: home, awayTeam: away,
                               homeScore: homeScore, awayScore: awayScore)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            events.insert(event, at: 0)
        }
    }

    private func finish() {
        guard phase != .finished else { return }
        timer?.invalidate(); timer = nil
        phase = .finished
        emit(.fulltime, side: .neutral, team: nil)
        Haptics.success()
    }
}
