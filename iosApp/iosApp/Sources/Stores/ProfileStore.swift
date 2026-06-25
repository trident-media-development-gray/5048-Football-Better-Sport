import SwiftUI
import UIKit

/// Stores the fan's personal profile — a display name and an avatar photo
/// chosen from the camera or the photo library. The name lives in
/// UserDefaults; the avatar is written to the Documents directory as a JPEG so
/// it survives relaunches without bloating UserDefaults.
final class ProfileStore: ObservableObject {
    @Published var displayName: String {
        didSet { UserDefaults.standard.set(displayName, forKey: Self.nameKey) }
    }
    @Published private(set) var avatar: UIImage?

    private static let nameKey = "profile.displayName"
    private static let avatarFile = "fan-avatar.jpg"

    init() {
        displayName = UserDefaults.standard.string(forKey: Self.nameKey) ?? ""
        avatar = Self.loadAvatar()
    }

    var hasAvatar: Bool { avatar != nil }

    /// First letter of the display name, used as a placeholder monogram.
    var monogram: String {
        let trimmed = displayName.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? "★" : String(trimmed.prefix(1)).uppercased()
    }

    // MARK: Avatar

    func setAvatar(_ image: UIImage?) {
        avatar = image
        if let image { Self.writeAvatar(image) } else { Self.deleteAvatar() }
        Haptics.success()
    }

    // MARK: Persistence helpers

    private static var avatarURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(avatarFile)
    }

    private static func loadAvatar() -> UIImage? {
        guard let data = try? Data(contentsOf: avatarURL) else { return nil }
        return UIImage(data: data)
    }

    private static func writeAvatar(_ image: UIImage) {
        // Downscale to a sensible avatar size before persisting.
        let resized = image.scaledToFit(maxDimension: 600)
        guard let data = resized.jpegData(compressionQuality: 0.85) else { return }
        try? data.write(to: avatarURL, options: .atomic)
    }

    private static func deleteAvatar() {
        try? FileManager.default.removeItem(at: avatarURL)
    }
}

private extension UIImage {
    /// Returns a copy whose longest side is at most `maxDimension` points,
    /// preserving aspect ratio. Avoids storing full-resolution camera shots.
    func scaledToFit(maxDimension: CGFloat) -> UIImage {
        let longest = max(size.width, size.height)
        guard longest > maxDimension else { return self }
        let scale = maxDimension / longest
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
