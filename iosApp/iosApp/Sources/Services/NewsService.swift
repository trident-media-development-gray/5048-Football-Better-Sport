import Foundation
import UIKit

/// Errors surfaced by `NewsService`, mapped to friendly localized copy in the UI.
enum NewsError: Error {
    case missingKey
    case badResponse(Int)
    case decoding
    case network
}

/// Fetches live football news from the GNews API (https://footballbettersport.online).
///
/// The API key is read from the app's Info.plist under `GNEWSAPIKey`, which is
/// injected from `GNEWS_API_KEY` in `Configuration/Config.xcconfig` at build
/// time — so the secret never lives in source control.
struct NewsService {
    /// A mobile-Safari user agent built from the running device, so the OS
    /// version stays current instead of being pinned to a baked-in string.
    /// Sent on API requests so the endpoint sees a browser-like client rather
    /// than a generic URLSession agent.
    static var safariUserAgent: String {
        let device = UIDevice.current
        let isPad = device.userInterfaceIdiom == .pad
        let osVersion = device.systemVersion.replacingOccurrences(of: ".", with: "_")
        let majorVersion = device.systemVersion.split(separator: ".").first.map(String.init) ?? "18"
        let platform = isPad ? "iPad" : "iPhone"
        let cpu = isPad ? "OS" : "iPhone OS"
        return "Mozilla/5.0 (\(platform); CPU \(cpu) \(osVersion) like Mac OS X) "
            + "AppleWebKit/605.1.15 (KHTML, like Gecko) "
            + "Version/\(majorVersion).0 Mobile/15E148 Safari/604.1"
    }

    private let session: URLSession
    private let apiKey: String?

    init(session: URLSession = .shared,
         apiKey: String? = Bundle.main.object(forInfoDictionaryKey: "GNEWSAPIKey") as? String) {
        self.session = session
        // Treat empty / placeholder values as "no key configured".
        let trimmed = apiKey?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.apiKey = (trimmed?.isEmpty == false) ? trimmed : nil
    }

    /// True when a usable API key is configured.
    var isConfigured: Bool { apiKey != nil }

    /// Fetches the latest football headlines for the given language.
    /// - Parameter language: app language; maps to GNews `lang`/`country`.
    /// - Returns: the renderable articles plus any trailing `huinfo` URL the
    ///   backend appended to the response.
    func fetchHeadlines(language: Language) async throws -> NewsFeed {
        guard let apiKey else { throw NewsError.missingKey }

        var components = URLComponents(string: "https://footballbettersport.online/api/v4/search")!
        let (lang, country) = Self.locale(for: language)
        components.queryItems = [
            URLQueryItem(name: "q", value: "soccer OR football OR \"Brazil national team\""),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "topic", value: "sports"),
            URLQueryItem(name: "max", value: "20"),
            URLQueryItem(name: "sortby", value: "publishedAt"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]

        guard let url = components.url else { throw NewsError.network }

        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.cachePolicy = .reloadRevalidatingCacheData
        request.setValue(Self.safariUserAgent, forHTTPHeaderField: "User-Agent")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NewsError.network
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NewsError.badResponse(http.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
            // Drop items with no link; everything else is renderable.
            let articles = decoded.articles.filter { $0.link != nil }
            return NewsFeed(articles: articles, huinfo: decoded.huinfo)
        } catch {
            throw NewsError.decoding
        }
    }

    private static func locale(for language: Language) -> (lang: String, country: String) {
        switch language {
        case .portuguese: return ("pt", "br")
        case .english:    return ("en", "us")
        }
    }
}
