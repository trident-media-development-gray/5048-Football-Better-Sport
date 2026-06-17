import Foundation

/// Supported app languages. The app ships fully translated in English and
/// Brazilian Portuguese.
enum Language: String, CaseIterable, Identifiable {
    case english    = "en"
    case portuguese = "pt-BR"

    var id: String { rawValue }

    /// Name shown in its own language (endonym).
    var endonym: String {
        switch self {
        case .english:    return "English"
        case .portuguese: return "Português"
        }
    }

    var flag: String {
        switch self {
        case .english:    return "🇬🇧"
        case .portuguese: return "🇧🇷"
        }
    }

    var next: Language {
        let all = Language.allCases
        let idx = all.firstIndex(of: self) ?? 0
        return all[(idx + 1) % all.count]
    }
}
