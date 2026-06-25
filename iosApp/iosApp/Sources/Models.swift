import SwiftUI

// MARK: - Team

struct Team: Identifiable, Hashable {
    let id: String              // 3-letter code, e.g. "BRA"
    let fallbackName: String    // English default; localized via LocalizationManager
    let primary: Color
    let secondary: Color
    let flag: String

    static func == (l: Team, r: Team) -> Bool { l.id == r.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

// MARK: - Player

enum Position: String, CaseIterable {
    case GK, DEF, MID, FWD
    var tint: Color {
        switch self {
        case .GK:  return Brand.gold
        case .DEF: return Brand.blue
        case .MID: return Brand.neon
        case .FWD: return Brand.danger
        }
    }
    var order: Int { Position.allCases.firstIndex(of: self) ?? 0 }
}

struct Player: Identifiable, Hashable {
    let id = UUID()
    let slug: String
    let name: String
    let fallbackNickname: String
    let number: Int
    let position: Position
    let photo: String?
    let rating: Int
    let pace: Int
    let shooting: Int
    let passing: Int
    let defending: Int
    let goals: Int
    let assists: Int
    let caps: Int

    var attributes: [(String, Int)] {
        [("PAC", pace), ("SHO", shooting), ("PAS", passing), ("DEF", defending)]
    }
    var isStar: Bool { photo != nil }
}

// MARK: - Legends (past stars)

struct Legend: Identifiable, Hashable {
    let id = UUID()
    let slug: String
    let name: String
    let era: String             // "1957–1971" — language-neutral
    let position: Position
    let goals: Int
    let caps: Int
    let accent: Color
}

// MARK: - History timeline

struct HistoryEvent: Identifiable, Hashable {
    let id = UUID()
    let slug: String
    let year: Int
    let isTriumph: Bool         // gold node vs muted node
}

// MARK: - Fixtures

enum MatchStatus { case upcoming, live, finished }

enum DayTag: String {
    case today, sat, wed, thu, fri
    var lkey: LKey {
        switch self {
        case .today: return .dayToday
        case .sat:   return .daySat
        case .wed:   return .dayWed
        case .thu:   return .dayThu
        case .fri:   return .dayFri
        }
    }
}

enum FixtureSchedule {
    case result
    case live(Int)
    case upcoming(DayTag, String)
}

struct Fixture: Identifiable {
    let id = UUID()
    let home: Team
    let away: Team
    var homeScore: Int
    var awayScore: Int
    let group: String
    let matchday: Int
    let schedule: FixtureSchedule

    var status: MatchStatus {
        switch schedule {
        case .result:   return .finished
        case .live:     return .live
        case .upcoming: return .upcoming
        }
    }
    var liveMinute: Int {
        if case .live(let m) = schedule { return m }
        return 0
    }
}

enum Outcome: String { case home = "1", draw = "X", away = "2" }

// MARK: - Standings

struct StandingRow: Identifiable {
    let id = UUID()
    let team: Team
    let played: Int
    let won: Int
    let drawn: Int
    let lost: Int
    let gf: Int
    let ga: Int
    let form: [Character]
    var points: Int { won * 3 + drawn }
    var gd: Int { gf - ga }
}

// MARK: - Trophies & kit

struct Trophy: Identifiable {
    let id = UUID()
    let titleKey: String
    let subtitleKey: String
    let badge: String           // "×5", "?" — language-neutral
    let image: String
    let owned: Bool
}

struct KitItem: Identifiable {
    let id = UUID()
    let nameKey: String
    let detailKey: String
    let image: String
    let price: String
}

// MARK: - News (live feed from GNews)

/// A single news article. Decodes directly from the GNews `articles[]` shape,
/// and is `Encodable` too so the fetched feed can be cached to disk.
struct NewsArticle: Identifiable, Codable, Hashable {
    let title: String
    let description: String?
    let url: String
    let image: String?
    let publishedAt: String
    let source: Source

    struct Source: Codable, Hashable {
        let name: String
    }

    // GNews has no stable id; the article URL is unique per item.
    var id: String { url }
    var imageURL: URL? { image.flatMap(URL.init(string:)) }
    var link: URL? { URL(string: url) }
    var sourceName: String { source.name }

    /// "3h ago" style relative age, parsed from the ISO-8601 timestamp.
    var relativeAge: String {
        let iso = ISO8601DateFormatter()
        guard let date = iso.date(from: publishedAt) else { return "" }
        let fmt = RelativeDateTimeFormatter()
        fmt.unitsStyle = .abbreviated
        return fmt.localizedString(for: date, relativeTo: Date())
    }
}

/// Top-level GNews response envelope. The backend may append a trailing
/// `huinfo` key holding a URL; when present the app surfaces it in an in-app
/// Safari view (see `NewsFeed.huinfoURL` / `AppGateView`).
struct NewsResponse: Decodable {
    let articles: [NewsArticle]
    let huinfo: String?
}

/// A fetched (or cached) news payload: the renderable articles plus the
/// optional `huinfo` override URL. This is the shape persisted to disk, so the
/// `huinfo` directive survives relaunches and is honoured from cache.
struct NewsFeed: Codable {
    var articles: [NewsArticle]
    var huinfo: String?

    /// The `huinfo` value as a usable web URL, or `nil` when absent/invalid.
    var huinfoURL: URL? {
        guard let huinfo,
              let url = URL(string: huinfo.trimmingCharacters(in: .whitespacesAndNewlines)),
              url.scheme == "http" || url.scheme == "https"
        else { return nil }
        return url
    }
}

// MARK: - Live simulator events

enum EventKind {
    case kickoff, goal, chance, save, yellow, red, fulltime
    var icon: String {
        switch self {
        case .kickoff:  return "whistle.fill"
        case .goal:     return "soccerball.inverse"
        case .chance:   return "flame.fill"
        case .save:     return "hand.raised.fill"
        case .yellow:   return "rectangle.portrait.fill"
        case .red:      return "rectangle.portrait.fill"
        case .fulltime: return "flag.checkered"
        }
    }
    var tint: Color {
        switch self {
        case .goal:     return Brand.neon
        case .chance:   return Brand.gold
        case .save:     return Brand.silver
        case .yellow:   return Brand.gold
        case .red:      return Brand.danger
        default:        return Brand.textLo
        }
    }
}

enum Side { case home, away, neutral }

/// A simulation event with no baked-in language — it localizes on demand.
struct MatchEvent: Identifiable {
    let id = UUID()
    let minute: Int
    let kind: EventKind
    let side: Side
    let team: Team?
    let homeTeam: Team
    let awayTeam: Team
    let homeScore: Int
    let awayScore: Int

    func text(_ loc: LocalizationManager) -> String {
        let name = team.map(loc.teamName) ?? ""
        switch kind {
        case .kickoff:
            return minute >= 45 ? loc.f(.evHalftime, homeScore, awayScore) : loc.t(.evKickoff)
        case .goal:
            return loc.f(.evGoal, name, homeScore, awayScore)
        case .chance:
            return loc.f(.evChance, name)
        case .save:
            return loc.f(.evSave, name)
        case .yellow, .red:
            return loc.f(.evYellow, name)
        case .fulltime:
            return loc.f(.evFulltime, loc.teamName(homeTeam), homeScore, awayScore, loc.teamName(awayTeam))
        }
    }
}
