import Foundation

/// Type-safe keys for every static UI string in the app.
/// Dynamic/content strings (team names, bios, …) use plain string keys
/// resolved through `LocalizationManager.string(_:)`.
enum LKey: String {
    // General
    case appName, headerSubtitle, done, settings, language, about, version
    case aboutBlurb, generalSection, contentSection, languageHint

    // Startup / connectivity
    case loadingTagline, offlineTitle, offlineMessage

    // Tabs
    case tabHub, tabGroup, tabSquad, tabHistory, tabCabinet, tabNews

    // News
    case newsTitle, newsSubtitle, newsEmpty, newsRetry
    case newsErrorNetwork, newsErrorServer, newsErrorKey, newsKeyHint

    // Profile
    case fanProfile, yourName, namePlaceholder, editPhoto, photoHint
    case takePhoto, chooseLibrary, removePhoto, cancel, tapToAddPhoto

    // Hub
    case predictEarn, starMen, featured, kickOff, resume, pause, playAgain
    case tapKickOff, paused, fullTime, live, draw, vs, nextFixtures

    // Table
    case groupDTitle, topTwoAdvance, colTeam, colForm, resultsFixtures
    case group, matchdayShort, fullTimeShort

    // Squad
    case filterAll, filterFavourites, noFavourites
    case attributes, season, statGoals, statAssists, statCaps
    case ovr, squadTitle

    // History
    case historyTitle, historyBlurb, timelineTitle, legendsTitle, legendsSub
    case honoursTitle, eraLabel, currentStarsTitle, capsLabel, goalsLabel

    // Cabinet
    case trophyCabinet, proShop, addToBag, addedToBag, inBag, bag, rankUpHint, fanPoints

    // Live-match events
    case evKickoff, evGoal, evChance, evSave, evYellow, evHalftime, evFulltime

    // Day tags
    case dayToday, daySat, dayWed, dayThu, dayFri
}
