import SwiftUI

/// Raw content store. Repositories read from here; nothing else should.
enum Catalog {

    // MARK: Teams

    static let bra = Team(id: "BRA", fallbackName: "Brazil",    primary: Brand.lime,           secondary: Brand.gold,           flag: "🇧🇷")
    static let arg = Team(id: "ARG", fallbackName: "Argentina", primary: Color(hex: 0x6CB7E8), secondary: .white,               flag: "🇦🇷")
    static let fra = Team(id: "FRA", fallbackName: "France",    primary: Color(hex: 0x2A4BD0), secondary: .white,               flag: "🇫🇷")
    static let esp = Team(id: "ESP", fallbackName: "Spain",     primary: Color(hex: 0xC8102E), secondary: Brand.gold,           flag: "🇪🇸")
    static let por = Team(id: "POR", fallbackName: "Portugal",  primary: Color(hex: 0xB81B22), secondary: Color(hex: 0x0B6B3A), flag: "🇵🇹")
    static let eng = Team(id: "ENG", fallbackName: "England",   primary: .white,               secondary: Color(hex: 0x1B2E86), flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿")
    static let ger = Team(id: "GER", fallbackName: "Germany",   primary: Color(hex: 0xE6E6E6), secondary: .black,               flag: "🇩🇪")
    static let uru = Team(id: "URU", fallbackName: "Uruguay",   primary: Color(hex: 0x5AA9E6), secondary: .black,               flag: "🇺🇾")
    static let cro = Team(id: "CRO", fallbackName: "Croatia",   primary: Color(hex: 0xC8102E), secondary: .white,               flag: "🇭🇷")
    static let ned = Team(id: "NED", fallbackName: "Netherlands", primary: Color(hex: 0xF36C21), secondary: .white,             flag: "🇳🇱")

    static let groupDTeams = [bra, esp, ned, cro]

    // MARK: Brazil squad (current stars)

    static let squad: [Player] = [
        Player(slug: "alisson",   name: "Alisson Becker",  fallbackNickname: "The Wall",   number: 1,  position: .GK,  photo: nil,       rating: 88, pace: 56, shooting: 24, passing: 78, defending: 86, goals: 0,  assists: 1,  caps: 71),
        Player(slug: "danilo",    name: "Danilo",          fallbackNickname: "The Soldier",number: 2,  position: .DEF, photo: nil,       rating: 81, pace: 76, shooting: 52, passing: 78, defending: 82, goals: 3,  assists: 6,  caps: 58),
        Player(slug: "militao",   name: "Éder Militão",    fallbackNickname: "Tank",       number: 3,  position: .DEF, photo: nil,       rating: 85, pace: 84, shooting: 45, passing: 72, defending: 86, goals: 2,  assists: 1,  caps: 38),
        Player(slug: "marquinhos",name: "Marquinhos",      fallbackNickname: "Captain",    number: 4,  position: .DEF, photo: nil,       rating: 86, pace: 80, shooting: 39, passing: 80, defending: 88, goals: 5,  assists: 2,  caps: 90),
        Player(slug: "beraldo",   name: "Lucas Beraldo",   fallbackNickname: "The Rampart",number: 6,  position: .DEF, photo: nil,       rating: 79, pace: 78, shooting: 30, passing: 74, defending: 80, goals: 1,  assists: 0,  caps: 11),
        Player(slug: "bruno",     name: "Bruno Guimarães", fallbackNickname: "The Maestro",number: 5,  position: .MID, photo: nil,       rating: 86, pace: 75, shooting: 74, passing: 87, defending: 80, goals: 6,  assists: 9,  caps: 41),
        Player(slug: "casemiro",  name: "Casemiro",        fallbackNickname: "The Anchor", number: 18, position: .MID, photo: nil,       rating: 84, pace: 62, shooting: 70, passing: 80, defending: 87, goals: 7,  assists: 4,  caps: 76),
        Player(slug: "paqueta",   name: "Lucas Paquetá",   fallbackNickname: "The Joker",  number: 7,  position: .MID, photo: "player3", rating: 84, pace: 79, shooting: 78, passing: 85, defending: 64, goals: 11, assists: 14, caps: 49),
        Player(slug: "rodrygo",   name: "Rodrygo Goes",    fallbackNickname: "The Rocket",  number: 10, position: .FWD, photo: "player1", rating: 87, pace: 91, shooting: 84, passing: 82, defending: 38, goals: 19, assists: 12, caps: 33),
        Player(slug: "vini",      name: "Vinícius Júnior", fallbackNickname: "Vini Jr",    number: 11, position: .FWD, photo: "player2", rating: 90, pace: 95, shooting: 86, passing: 80, defending: 34, goals: 24, assists: 16, caps: 39),
        Player(slug: "raphinha",  name: "Raphinha",        fallbackNickname: "Pinga",      number: 19, position: .FWD, photo: nil,       rating: 85, pace: 88, shooting: 82, passing: 81, defending: 45, goals: 15, assists: 13, caps: 40),
        Player(slug: "endrick",   name: "Endrick",         fallbackNickname: "The Future", number: 9,  position: .FWD, photo: nil,       rating: 81, pace: 89, shooting: 83, passing: 70, defending: 30, goals: 9,  assists: 3,  caps: 14),
    ]

    // MARK: Legends (stars of the past)

    static let legends: [Legend] = [
        Legend(slug: "pele",          name: "Pelé",            era: "1957–1971", position: .FWD, goals: 77,  caps: 92,  accent: Brand.gold),
        Legend(slug: "garrincha",     name: "Garrincha",       era: "1955–1966", position: .FWD, goals: 12,  caps: 50,  accent: Brand.neon),
        Legend(slug: "zico",          name: "Zico",            era: "1976–1986", position: .MID, goals: 48,  caps: 71,  accent: Brand.lime),
        Legend(slug: "socrates",      name: "Sócrates",        era: "1979–1986", position: .MID, goals: 22,  caps: 60,  accent: Brand.silver),
        Legend(slug: "romario",       name: "Romário",         era: "1987–2005", position: .FWD, goals: 55,  caps: 70,  accent: Brand.gold),
        Legend(slug: "ronaldo",       name: "Ronaldo",         era: "1994–2011", position: .FWD, goals: 62,  caps: 98,  accent: Brand.danger),
        Legend(slug: "ronaldinho",    name: "Ronaldinho",      era: "1999–2013", position: .FWD, goals: 33,  caps: 97,  accent: Brand.neon),
        Legend(slug: "robertocarlos", name: "Roberto Carlos",  era: "1992–2006", position: .DEF, goals: 11,  caps: 125, accent: Brand.blue),
        Legend(slug: "cafu",          name: "Cafu",            era: "1990–2006", position: .DEF, goals: 5,   caps: 142, accent: Brand.gold),
    ]

    // MARK: History timeline

    static let history: [HistoryEvent] = [
        HistoryEvent(slug: "wc1950",        year: 1950, isTriumph: false),
        HistoryEvent(slug: "wc1958",        year: 1958, isTriumph: true),
        HistoryEvent(slug: "wc1962",        year: 1962, isTriumph: true),
        HistoryEvent(slug: "wc1970",        year: 1970, isTriumph: true),
        HistoryEvent(slug: "sel1982",       year: 1982, isTriumph: false),
        HistoryEvent(slug: "wc1994",        year: 1994, isTriumph: true),
        HistoryEvent(slug: "wc2002",        year: 2002, isTriumph: true),
        HistoryEvent(slug: "mineirazo2014", year: 2014, isTriumph: false),
        HistoryEvent(slug: "copa2019",      year: 2019, isTriumph: true),
        HistoryEvent(slug: "copa2026",      year: 2026, isTriumph: false),
    ]

    // MARK: Fixtures (drive both the table and the fixtures list)

    static let fixtures: [Fixture] = [
        Fixture(home: bra, away: cro, homeScore: 2, awayScore: 0, group: "D", matchday: 1, schedule: .result),
        Fixture(home: esp, away: ned, homeScore: 1, awayScore: 1, group: "D", matchday: 1, schedule: .result),
        Fixture(home: arg, away: por, homeScore: 1, awayScore: 0, group: "F", matchday: 2, schedule: .live(67)),
        Fixture(home: bra, away: esp, homeScore: 0, awayScore: 0, group: "D", matchday: 3, schedule: .upcoming(.wed, "21:00")),
        Fixture(home: fra, away: eng, homeScore: 0, awayScore: 0, group: "C", matchday: 3, schedule: .upcoming(.thu, "18:00")),
        Fixture(home: ger, away: uru, homeScore: 0, awayScore: 0, group: "A", matchday: 3, schedule: .upcoming(.fri, "21:00")),
    ]

    static var featured: Fixture {
        Fixture(home: bra, away: arg, homeScore: 0, awayScore: 0, group: "D", matchday: 2, schedule: .upcoming(.today, "21:00"))
    }

    // MARK: Trophy cabinet

    static let trophies: [Trophy] = [
        Trophy(titleKey: "trophy.worldcup.title",    subtitleKey: "trophy.worldcup.sub",    badge: "×5", image: "trophy", owned: true),
        Trophy(titleKey: "trophy.copaamerica.title", subtitleKey: "trophy.copaamerica.sub", badge: "×9", image: "trophy", owned: true),
        Trophy(titleKey: "trophy.confed.title",      subtitleKey: "trophy.confed.sub",      badge: "×4", image: "trophy", owned: true),
        Trophy(titleKey: "trophy.copa2026.title",    subtitleKey: "trophy.copa2026.sub",    badge: "?",  image: "crest",  owned: false),
    ]

    // MARK: Pro shop

    static let kit: [KitItem] = [
        KitItem(nameKey: "kit.jersey.name",  detailKey: "kit.jersey.detail",  image: "jersey",      price: "$129"),
        KitItem(nameKey: "kit.boot.name",    detailKey: "kit.boot.detail",    image: "boot",        price: "$249"),
        KitItem(nameKey: "kit.whistle.name", detailKey: "kit.whistle.detail", image: "whistle",     price: "$24"),
        KitItem(nameKey: "kit.flag.name",    detailKey: "kit.flag.detail",    image: "flag_brazil", price: "$39"),
    ]
}
