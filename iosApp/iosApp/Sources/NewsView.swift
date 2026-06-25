import SwiftUI

struct NewsView: View {
    @EnvironmentObject var loc: LocalizationManager
    // Headlines are prefetched and cached at app start by `NewsStore`, so the
    // tab renders instantly; pull-to-refresh and language changes refetch.
    @EnvironmentObject var news: NewsStore
    @State private var openURL: IdentifiedURL?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                header
                content
                Color.clear.frame(height: 8)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .readableWidth()
        }
        // Pull-to-refresh is the only trigger that updates the cached feed.
        .refreshable { await news.refresh(language: loc.language) }
        .sheet(item: $openURL) { item in
            SafariView(url: item.url).ignoresSafeArea()
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(loc.t(.newsTitle))
                    .font(.display(26, .black))
                    .foregroundStyle(Brand.textHi)
                Text(loc.t(.newsSubtitle))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Brand.textLo)
            }
            Spacer()
            Image(systemName: "newspaper.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Brand.neon)
        }
        .padding(.top, 8)
    }

    // MARK: Content states

    @ViewBuilder
    private var content: some View {
        if !news.isConfigured {
            message(icon: "key.slash", title: loc.t(.newsErrorKey), detail: loc.t(.newsKeyHint))
        } else if news.articles.isEmpty {
            message(icon: "tray", title: loc.t(.newsEmpty), detail: nil)
        } else {
            ForEach(news.articles) { article in
                Button { open(article) } label: { NewsCard(article: article) }
                    .buttonStyle(PressStyle())
            }
        }
    }

    private func message(icon: String, title: String, detail: String?) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Brand.textLo)
            Text(title)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textHi)
                .multilineTextAlignment(.center)
            if let detail {
                Text(detail)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.textLo)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private func open(_ article: NewsArticle) {
        guard let url = article.link else { return }
        Haptics.tap()
        openURL = IdentifiedURL(url: url)
    }
}

// MARK: - Card

struct NewsCard: View {
    let article: NewsArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let imageURL = article.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            placeholder
                        case .empty:
                            placeholder.overlay(ProgressView().tint(Brand.textLo))
                        @unknown default:
                            placeholder
                        }
                    }
                } else {
                    // Article has no image — show the branded placeholder.
                    placeholder
                }
            }
            .frame(height: 168)
            .frame(maxWidth: .infinity)
            .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.textHi)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                if let description = article.description, !description.isEmpty {
                    Text(description)
                        .font(.system(size: 12.5, weight: .medium, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                        .lineLimit(2)
                }
                HStack(spacing: 6) {
                    Pill(text: article.sourceName, fg: Brand.ink, bg: Brand.neon)
                    Spacer()
                    if !article.relativeAge.isEmpty {
                        Text(article.relativeAge)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Brand.textLo)
                    }
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Brand.neon)
                }
                .padding(.top, 2)
            }
            .padding(14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(20)
    }

    private var placeholder: some View {
        ZStack {
            Brand.blueGrad
            Image(systemName: "soccerball")
                .font(.system(size: 40, weight: .regular))
                .foregroundStyle(Brand.textHi.opacity(0.18))
            Image("crest").resizable().scaledToFit()
                .frame(width: 48, height: 48)
                .opacity(0.85)
        }
    }
}

/// Wraps a URL so it can drive a `.sheet(item:)`.
struct IdentifiedURL: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
}
