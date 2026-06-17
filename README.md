# Seleção — Football Better Sport

A native **iOS / SwiftUI** companion app for Brazil's run at *Copa 2026*. Pure Swift,
no Android, no Kotlin, no multiplatform — just one focused iPhone app.

The visual language is taken straight from the trophy mockup: deep navy, neon lime
green, gold and silver on a near-black pitch.

## Languages

The app is **fully localized in English and Brazilian Portuguese** — every label, the
live-match commentary, team names, player nicknames, legend bios and the history timeline.
Tap the flag pill in the Hub header to switch instantly, or use **Settings** (gear icon in
the Cabinet) for the full picker. The choice persists between launches.

## Features

- **Hub** — an interactive **live-match simulator** (Brazil vs Argentina). Tap *Kick-Off*
  and the clock runs in real time: goals, chances, saves and cards stream into a live
  event feed with haptics. Pause, resume or replay. Below it, a **prediction game** —
  call the result of upcoming fixtures to earn fan points.
- **Group** — the Group D table, **computed live from fixtures** by a standings engine
  (points / goal difference / goals), with form guides and the results & fixtures list.
- **Squad** — the full Brazil squad as rating cards (filterable by position). Tap any
  player for a detail screen with a full-bleed photo, animated attribute bars and season
  stats. Favourite players to earn points.
- **History** — *A Seleção*: a World Cup **timeline** from the 1950 Maracanazo to the hunt
  for a sixth star, a **Hall of Fame** of legends (Pelé, Garrincha, Zico, Sócrates, Romário,
  Ronaldo, Ronaldinho, Roberto Carlos, Cafu) with bios & honours, and today's stars.
- **Cabinet** — the trophy cabinet (5× World Cups & more), a fan-level progress system,
  a Pro Shop with kit/boots/whistle/flag, and **Settings** (language + about).

## Architecture

Layered MVVM with dependency injection:

- **`AppEnvironment`** — a DI container wiring repositories, services and stores, injected
  via the SwiftUI environment.
- **Repositories** (`Data/`) — protocol-based data access (`SquadRepository`,
  `FixtureRepository`, `LegendRepository`, `HistoryRepository`, …) with in-memory impls.
- **Services** (`Services/`) — `StandingsCalculator` (derives the table from fixtures),
  `FanProgression` (levelling curve), and a protocol-driven `MatchSimulator` with a
  pluggable `MatchEventGenerating` probability model.
- **View models** (`ViewModels/`) — one per screen, holding logic and state.
- **Localization** (`Localization/`) — `LocalizationManager` (observable), a typed `LKey`
  enum for UI strings and dotted keys for content, with English + pt-BR tables.

## Project layout

```
iosApp/
├── project.yml                 ← XcodeGen spec (source of truth for the project)
├── Configuration/Config.xcconfig
└── iosApp/
    ├── Info.plist
    ├── Assets.xcassets/         ← app icon, accent colour, all imagery
    └── Sources/                 ← all SwiftUI code
        ├── App.swift            ← @main entry
        ├── Theme.swift          ← brand palette, gradients, haptics
        ├── Models.swift         ← Team, Player, Legend, HistoryEvent, Fixture, …
        ├── SampleData.swift     ← Catalog: squad, legends, history, fixtures, kit
        ├── Components.swift     ← reusable views (badges, bars, pills)
        ├── Core/
        │   └── AppEnvironment.swift     ← DI container
        ├── Localization/
        │   ├── Language.swift · LocalizationKeys.swift
        │   ├── Translations.swift       ← EN + pt-BR tables
        │   └── LocalizationManager.swift
        ├── Data/Repositories.swift      ← repository protocols + impls
        ├── Services/
        │   ├── StandingsCalculator.swift · FanProgression.swift
        │   └── MatchSimulator.swift     ← protocol-driven live engine
        ├── Stores/FanStore.swift
        ├── ViewModels/                  ← Hub / Table / Squad / History / Cabinet
        ├── Views/SettingsView.swift
        ├── RootView.swift               ← custom tab bar + navigation
        ├── HubView.swift · TableView.swift · SquadView.swift
        ├── HistoryView.swift · CabinetView.swift
```

## Build & run

Requirements: Xcode 15+, iOS 16.6+ simulator or device.

```bash
open iosApp/iosApp.xcodeproj      # then ⌘R
```

If you change `project.yml`, regenerate the project:

```bash
brew install xcodegen
cd iosApp && xcodegen generate
```

## Assets

Source artwork lives in `5048-Assets/` and is imported into
`iosApp/iosApp/Assets.xcassets` as: `crest`, `trophy`, `jersey`, `boot`, `whistle`,
`flag_brazil`, `bg1`–`bg3`, and `player1`–`player3`.
