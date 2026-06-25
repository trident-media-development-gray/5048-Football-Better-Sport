import SwiftUI

// MARK: - App-start gate

/// Gates the app on the initial news fetch: a branded loading screen while the
/// fetch runs, a no-connection screen (with retry) if it fails, and the main
/// app once the data is in hand. The shared `NewsStore` is created here and
/// injected so the News tab reuses the already-fetched, cached headlines.
struct AppGateView: View {
    @EnvironmentObject var loc: LocalizationManager
    @StateObject private var news = NewsStore()
    // Remembers the active `huinfo` URL so the gate can re-present itself if the
    // Safari Done button dismisses the cover (see `fullScreenCover` below).
    @State private var huinfoURL: URL?

    var body: some View {
        ZStack {
            switch news.phase {
            case .loading:
                LoadingScreen()
                    .transition(.opacity)
            case .failed:
                NoConnectionScreen {
                    Task { await news.retry(language: loc.language) }
                }
                .transition(.opacity)
            case .ready:
                RootView()
                    .transition(.opacity)
            }
        }
        .environmentObject(news)
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.35), value: news.phase)
        .task { await news.start(language: loc.language) }
        // A `huinfo` URL in the fetched/cached feed takes over the app in a
        // full-screen in-app Safari view. The Safari Done button is a no-op: on
        // dismiss the cover re-presents itself, so the gate can't be escaped.
        .fullScreenCover(item: $news.huinfoTarget, onDismiss: {
            if let url = huinfoURL {
                news.huinfoTarget = IdentifiedURL(url: url)
            }
        }) { target in
            SafariView(url: target.url)
                .ignoresSafeArea()
                .onAppear { huinfoURL = target.url }
        }
    }
}

// MARK: - Loading screen

/// Branded splash shown while the app loads its data.
struct LoadingScreen: View {
    @EnvironmentObject var loc: LocalizationManager
    @State private var pulse = false
    @State private var spin = false

    var body: some View {
        ZStack {
            PageBackground()
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Brand.limeGrad)
                        .frame(width: 130, height: 130)
                        .opacity(0.18)
                        .scaleEffect(pulse ? 1.18 : 0.9)
                        .blur(radius: 10)
                    Image("crest")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .scaleEffect(pulse ? 1.04 : 0.96)
                        .neonGlow(Brand.neon, radius: 18)
                }
                .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: pulse)

                VStack(spacing: 6) {
                    Text(loc.t(.appName))
                        .font(.display(24, .black))
                        .foregroundStyle(Brand.textHi)
                    Text(loc.t(.loadingTagline))
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                }

                // Branded indeterminate spinner.
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Brand.limeGrad,
                            style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(spin ? 360 : 0))
                    .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: spin)
                    .padding(.top, 4)
            }
            .padding(40)
        }
        .onAppear { pulse = true; spin = true }
    }
}

// MARK: - No-connection screen

/// Shown when the app-start fetch fails. The retry hands control back to the
/// `NewsStore`, which returns to the loading screen and refetches.
struct NoConnectionScreen: View {
    @EnvironmentObject var loc: LocalizationManager
    let retry: () -> Void
    @State private var appeared = false

    var body: some View {
        ZStack {
            PageBackground()
            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Brand.cardGrad)
                        .frame(width: 110, height: 110)
                        .overlay(Circle().stroke(Brand.navyLine, lineWidth: 1))
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(Brand.neon)
                }

                VStack(spacing: 8) {
                    Text(loc.t(.offlineTitle))
                        .font(.display(22, .black))
                        .foregroundStyle(Brand.textHi)
                    Text(loc.t(.offlineMessage))
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 12)

                Button {
                    Haptics.tap()
                    retry()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text(loc.t(.newsRetry))
                    }
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.ink)
                    .padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Capsule().fill(Brand.limeGrad))
                    .neonGlow(Brand.neon, radius: 12)
                }
                .buttonStyle(PressStyle())
                .padding(.top, 6)
            }
            .padding(40)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.5, dampingFraction: 0.85), value: appeared)
        }
        .onAppear { appeared = true }
    }
}
