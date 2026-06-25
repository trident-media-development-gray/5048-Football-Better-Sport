import SwiftUI

/// On-disk cache for the latest fetched headlines, so the News tab can render
/// instantly on relaunch and survive brief offline spells.
struct NewsCache {
    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        return dir.appendingPathComponent("news_headlines.json")
    }()

    func load() -> NewsFeed? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        // Current format: the full feed (articles + optional huinfo).
        if let feed = try? JSONDecoder().decode(NewsFeed.self, from: data) {
            return feed
        }
        // Back-compat: older builds cached a bare article array.
        if let articles = try? JSONDecoder().decode([NewsArticle].self, from: data) {
            return NewsFeed(articles: articles, huinfo: nil)
        }
        return nil
    }

    func save(_ feed: NewsFeed) {
        guard let data = try? JSONEncoder().encode(feed) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}

/// Single source of truth for live football news.
///
/// The fetch is kicked off once at app start (see `AppGateView`) and the result
/// is cached — in memory for the session and on disk for relaunches — so the
/// News tab renders instantly without re-hitting the network. A failed startup
/// fetch surfaces the no-connection gate; pull-to-refresh failures stay silent
/// and keep the cached headlines on screen.
@MainActor
final class NewsStore: ObservableObject {
    enum Phase: Equatable {
        case loading            // app start: fetching — show the loading screen
        case ready              // headlines in hand (possibly empty / unconfigured)
        case failed(LKey)       // startup fetch failed — show the no-connection screen
    }

    @Published private(set) var phase: Phase = .loading
    @Published private(set) var articles: [NewsArticle]

    /// When the fetched (or cached) feed carries a trailing `huinfo` URL, this
    /// drives a full-screen in-app Safari view at the app gate. Settable so the
    /// presented cover can clear it on dismiss.
    @Published var huinfoTarget: IdentifiedURL?

    let isConfigured: Bool
    private let service: NewsService
    private let cache: NewsCache

    init(service: NewsService = AppEnvironment.shared.newsService, cache: NewsCache = NewsCache()) {
        self.service = service
        self.cache = cache
        self.isConfigured = service.isConfigured
        let cached = cache.load()
        self.articles = cached?.articles ?? []
        // Honour a cached `huinfo` directive immediately on relaunch.
        self.huinfoTarget = cached?.huinfoURL.map { IdentifiedURL(url: $0) }
        // Cached headlines present → open straight into the app with them and
        // skip the loading / no-connection gate entirely. The feed then only
        // updates on an explicit user refresh (pull-to-refresh). A cold start
        // with no cache still shows the loading screen while the first fetch runs.
        let hasCachedArticles = !(cached?.articles.isEmpty ?? true)
        self.phase = (!hasCachedArticles && isConfigured) ? .loading : .ready
    }

    /// Initial app-start load. No-ops once `.ready` — so when cached data was
    /// found in `init`, this never hits the network; the gate is skipped and the
    /// cached headlines are shown immediately.
    func start(language: Language) async {
        if case .ready = phase { return }
        await fetch(language: language, gated: true)
    }

    /// Retry from the no-connection screen: back to the loading screen, refetch.
    func retry(language: Language) async {
        phase = .loading
        await fetch(language: language, gated: true)
    }

    /// Pull-to-refresh (or language change) from the News tab. Failures keep the
    /// cached articles and never knock the app back to the gate.
    func refresh(language: Language) async {
        await fetch(language: language, gated: false)
    }

    private func fetch(language: Language, gated: Bool) async {
        // Without an API key the live feed can't run — don't trap the whole app
        // behind the gate; let it through and surface the hint on the News tab.
        guard isConfigured else { phase = .ready; return }

        do {
            let feed = try await service.fetchHeadlines(language: language)
            articles = feed.articles
            cache.save(feed)
            // A fresh `huinfo` surfaces the Safari view; its absence clears it.
            huinfoTarget = feed.huinfoURL.map { IdentifiedURL(url: $0) }
            phase = .ready
        } catch let error as NewsError where gated {
            phase = .failed(Self.messageKey(for: error))
        } catch {
            // Refresh failure: keep the current articles and stay ready.
            if gated { phase = .failed(.newsErrorNetwork) }
        }
    }

    private static func messageKey(for error: NewsError) -> LKey {
        switch error {
        case .missingKey:  return .newsErrorKey
        case .badResponse: return .newsErrorServer
        case .decoding:    return .newsErrorServer
        case .network:     return .newsErrorNetwork
        }
    }
}
