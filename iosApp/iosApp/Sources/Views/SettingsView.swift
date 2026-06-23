import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var loc: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Brand.page.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    handle
                    languageCard
                    aboutCard
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
                .readableWidth()
            }
        }
    }

    private var handle: some View {
        HStack {
            Text(loc.t(.settings))
                .font(.display(24, .black))
                .foregroundStyle(Brand.textHi)
            Spacer()
            Button { dismiss() } label: {
                Text(loc.t(.done))
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(Brand.neon)
            }
        }
        .padding(.top, 18)
    }

    private var languageCard: some View {
        VStack(spacing: 14) {
            HStack {
                SectionHeader(title: loc.t(.language))
                Spacer()
            }
            ForEach(Language.allCases) { lang in
                languageRow(lang)
            }
            Text(loc.t(.languageHint))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .cardSurface()
    }

    private func languageRow(_ lang: Language) -> some View {
        let selected = loc.language == lang
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { loc.setLanguage(lang) }
        } label: {
            HStack(spacing: 12) {
                Text(lang.flag).font(.system(size: 26))
                VStack(alignment: .leading, spacing: 1) {
                    Text(lang.endonym)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.textHi)
                    Text(lang.rawValue.uppercased())
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                }
                Spacer()
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(selected ? Brand.neon : Brand.navyLine)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(selected ? Brand.navyCard : Brand.navy.opacity(0.5)))
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(selected ? Brand.neon.opacity(0.6) : Brand.navyLine, lineWidth: 1))
        }
        .buttonStyle(PressStyle())
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: loc.t(.about))
            HStack(spacing: 12) {
                Image("crest").resizable().scaledToFit().frame(width: 44, height: 44)
                VStack(alignment: .leading, spacing: 2) {
                    Text(loc.t(.appName))
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.textHi)
                    Text("\(loc.t(.version)) 1.0")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                }
                Spacer()
            }
            Text(loc.t(.aboutBlurb))
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardSurface()
    }
}
