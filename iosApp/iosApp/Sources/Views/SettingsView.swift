import SwiftUI
import PhotosUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var profile: ProfileStore
    @Environment(\.dismiss) private var dismiss

    @State private var showPhotoOptions = false
    @State private var showCamera = false
    @State private var libraryItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            Brand.page.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    handle
                    profileCard
                    languageCard
                    aboutCard
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
                .readableWidth()
            }
        }
        // Camera capture (real device only; auto-prompts for permission).
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker { image in profile.setAvatar(image) }
                .ignoresSafeArea()
        }
        // Photo-library selection.
        .photosPicker(isPresented: photosPickerBinding, selection: $libraryItem, matching: .images)
        .onChange(of: libraryItem) { item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run { profile.setAvatar(image) }
                }
                await MainActor.run { libraryItem = nil }
            }
        }
        .confirmationDialog(loc.t(.editPhoto), isPresented: $showPhotoOptions, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button(loc.t(.takePhoto)) { showCamera = true }
            }
            Button(loc.t(.chooseLibrary)) { showLibrary = true }
            if profile.hasAvatar {
                Button(loc.t(.removePhoto), role: .destructive) { profile.setAvatar(nil) }
            }
            Button(loc.t(.cancel), role: .cancel) {}
        }
    }

    // The `.photosPicker` modifier needs an isPresented binding; drive it from
    // a transient flag so the confirmation dialog can trigger it.
    @State private var showLibrary = false
    private var photosPickerBinding: Binding<Bool> {
        Binding(get: { showLibrary }, set: { showLibrary = $0 })
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

    // MARK: Fan profile

    private var profileCard: some View {
        VStack(spacing: 16) {
            HStack {
                SectionHeader(title: loc.t(.fanProfile))
                Spacer()
            }
            HStack(spacing: 16) {
                avatarButton
                VStack(alignment: .leading, spacing: 8) {
                    Text(loc.t(.yourName))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                    TextField(loc.t(.namePlaceholder), text: $profile.displayName)
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.textHi)
                        .tint(Brand.neon)
                        .submitLabel(.done)
                    Button { Haptics.tap(); showPhotoOptions = true } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "camera.fill").font(.system(size: 11, weight: .bold))
                            Text(loc.t(.editPhoto))
                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                        }
                        .foregroundStyle(Brand.neon)
                    }
                    .buttonStyle(PressStyle())
                }
                Spacer()
            }
            Text(loc.t(.photoHint))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .cardSurface()
    }

    private var avatarButton: some View {
        Button { Haptics.tap(); showPhotoOptions = true } label: {
            ZStack {
                Circle().fill(Brand.blueGrad).frame(width: 76, height: 76)
                if let avatar = profile.avatar {
                    Image(uiImage: avatar).resizable().scaledToFill()
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                } else {
                    Text(profile.monogram)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.textHi)
                }
            }
            .overlay(Circle().stroke(Brand.gold.opacity(0.6), lineWidth: 1.5))
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "camera.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Brand.neon)
                    .background(Circle().fill(Brand.ink))
            }
        }
        .buttonStyle(PressStyle())
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
