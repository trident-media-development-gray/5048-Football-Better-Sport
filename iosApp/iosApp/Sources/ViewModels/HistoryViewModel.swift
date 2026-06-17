import SwiftUI

final class HistoryViewModel: ObservableObject {
    @Published private(set) var timeline: [HistoryEvent]
    @Published private(set) var legends: [Legend]
    @Published private(set) var currentStars: [Player]

    init(env: AppEnvironment = .shared) {
        self.timeline = env.historyRepository.timeline()
        self.legends = env.legendRepository.all()
        self.currentStars = env.squadRepository.stars()
    }
}
