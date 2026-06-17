import SwiftUI

/// Central translation service. Observed by the UI so a language change
/// instantly re-renders every screen.
final class LocalizationManager: ObservableObject {
    @Published private(set) var language: Language

    private static let storageKey = "app.language"
    private let tables: [Language: [String: String]]

    init(tables: [Language: [String: String]] = Translations.tables) {
        self.tables = tables
        if let raw = UserDefaults.standard.string(forKey: Self.storageKey),
           let saved = Language(rawValue: raw) {
            language = saved
        } else if Locale.preferredLanguages.first?.hasPrefix("pt") == true {
            language = .portuguese
        } else {
            language = .english
        }
    }

    func setLanguage(_ lang: Language) {
        guard lang != language else { return }
        language = lang
        UserDefaults.standard.set(lang.rawValue, forKey: Self.storageKey)
        Haptics.tap()
    }

    func toggleLanguage() { setLanguage(language.next) }

    // MARK: Lookup

    func string(_ key: String, _ fallback: String? = nil) -> String {
        tables[language]?[key]
            ?? tables[.english]?[key]
            ?? fallback
            ?? key
    }

    func t(_ key: LKey) -> String { string(key.rawValue) }

    func f(_ key: LKey, _ args: CVarArg...) -> String {
        String(format: t(key), locale: Locale(identifier: language.rawValue), arguments: args)
    }

    // MARK: Domain helpers

    func teamName(_ team: Team) -> String { string("team.\(team.id)", team.fallbackName) }

    func positionLong(_ p: Position) -> String { string("posLong.\(p.rawValue)") }

    func nickname(_ player: Player) -> String { string("nick.\(player.slug)", player.fallbackNickname) }

    func legendNickname(_ legend: Legend) -> String { string("legendNick.\(legend.slug)") }
    func legendBio(_ legend: Legend) -> String { string("legend.\(legend.slug).bio") }
    func legendHonour(_ legend: Legend) -> String { string("legend.\(legend.slug).honour") }

    func trophyTitle(_ t: Trophy) -> String { string(t.titleKey) }
    func trophySubtitle(_ t: Trophy) -> String { string(t.subtitleKey) }

    func kitName(_ k: KitItem) -> String { string(k.nameKey) }
    func kitDetail(_ k: KitItem) -> String { string(k.detailKey) }

    func levelTitle(_ key: String) -> String { string(key) }

    func historyTitle(_ e: HistoryEvent) -> String { string("history.\(e.slug).title") }
    func historyDetail(_ e: HistoryEvent) -> String { string("history.\(e.slug).detail") }

    func stage(_ f: Fixture) -> String {
        "\(t(.group)) \(f.group) · \(t(.matchdayShort))\(f.matchday)"
    }

    func kickoffLabel(_ f: Fixture) -> String {
        switch f.schedule {
        case .result:                 return t(.fullTimeShort)
        case .live(let m):            return "\(m)'"
        case .upcoming(let day, let time): return "\(t(day.lkey)) · \(time)"
        }
    }
}
