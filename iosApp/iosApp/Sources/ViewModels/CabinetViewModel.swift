import SwiftUI

final class CabinetViewModel: ObservableObject {
    @Published private(set) var trophies: [Trophy]
    @Published private(set) var kit: [KitItem]
    @Published var selectedKit: KitItem? = nil

    init(env: AppEnvironment = .shared) {
        self.trophies = env.trophyRepository.all()
        self.kit = env.kitRepository.all()
    }

    func present(_ item: KitItem) {
        Haptics.tap()
        selectedKit = item
    }
}
