import SwiftUI

struct CabinetView: View {
    @Binding var showSettings: Bool
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var fan: FanStore
    @StateObject private var model = CabinetViewModel()
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] { AppLayout.gridColumns(sizeClass) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                fanCard
                trophies
                shop
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .readableWidth()
        }
        .sheet(item: $model.selectedKit) { item in
            KitDetailSheet(item: item)
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: Fan level

    private var fanCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                Image("crest").resizable().scaledToFit()
                    .frame(width: 52, height: 52)
                VStack(alignment: .leading, spacing: 2) {
                    Text(loc.levelTitle(fan.level.titleKey))
                        .font(.display(22, .black))
                        .foregroundStyle(Brand.gold)
                    Text(loc.f(.fanPoints, fan.points))
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                }
                Spacer()
                Button { Haptics.tap(); showSettings = true } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Brand.textHi)
                        .padding(10)
                        .background(Circle().fill(Brand.navy.opacity(0.6)))
                }
                .buttonStyle(PressStyle())
            }
            VStack(spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Brand.navy)
                        Capsule().fill(Brand.goldGrad)
                            .frame(width: max(12, geo.size.width * fan.levelProgress))
                    }
                }
                .frame(height: 10)
                HStack {
                    Text(loc.t(.rankUpHint))
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(Brand.textLo)
                    Spacer()
                    Text("\(fan.points)/\(fan.nextThreshold)")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.gold)
                }
            }
        }
        .padding(18)
        .background(
            ZStack {
                Brand.cardGrad
                Image("bg1").resizable().scaledToFill().opacity(0.12)
            }
        )
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(Brand.gold.opacity(0.4), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    // MARK: Trophies

    private var trophies: some View {
        VStack(spacing: 12) {
            SectionHeader(title: loc.t(.trophyCabinet))
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(model.trophies) { trophy in
                    TrophyCard(trophy: trophy)
                }
            }
        }
    }

    // MARK: Shop

    private var shop: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionHeader(title: loc.t(.proShop))
                if fan.bagCount > 0 {
                    HStack(spacing: 5) {
                        Image(systemName: "bag.fill").font(.system(size: 11, weight: .bold))
                        Text("\(fan.bagCount)")
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .contentTransition(.numericText())
                    }
                    .foregroundStyle(Brand.ink)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Capsule().fill(Brand.limeGrad))
                    .neonGlow(Brand.neon, radius: 6)
                }
            }
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(model.kit) { item in
                    Button { model.present(item) } label: {
                        KitCard(item: item)
                    }
                    .buttonStyle(PressStyle())
                }
            }
        }
    }
}

struct TrophyCard: View {
    let trophy: Trophy
    @EnvironmentObject var loc: LocalizationManager

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Image(trophy.image).resizable().scaledToFit()
                    .frame(height: 110)
                    .saturation(trophy.owned ? 1 : 0.15)
                    .opacity(trophy.owned ? 1 : 0.55)
                if trophy.owned {
                    Text(trophy.badge)
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(Brand.ink)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Capsule().fill(Brand.goldGrad))
                        .offset(x: 40, y: -38)
                }
            }
            Text(loc.trophyTitle(trophy))
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textHi)
            Text(loc.trophySubtitle(trophy))
                .font(.system(size: 10.5, weight: .medium, design: .rounded))
                .foregroundStyle(Brand.textLo)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16).padding(.horizontal, 10)
        .cardSurface(20)
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(trophy.owned ? Brand.gold.opacity(0.45) : .clear, lineWidth: 1))
    }
}

struct KitCard: View {
    let item: KitItem
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var fan: FanStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [Brand.royal.opacity(0.5), Brand.navy],
                                         startPoint: .top, endPoint: .bottom))
                Image(item.image).resizable().scaledToFit().padding(14)
            }
            .frame(height: 120)
            .overlay(alignment: .topTrailing) {
                if fan.isInBag(item) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Brand.neon)
                        .padding(8)
                        .shadow(color: .black.opacity(0.4), radius: 3)
                }
            }

            Text(loc.kitName(item))
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(Brand.textHi)
                .lineLimit(1)
            HStack {
                Text(loc.kitDetail(item))
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.textLo)
                    .lineLimit(1)
                Spacer()
                Text(item.price)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.neon)
            }
        }
        .padding(12)
        .cardSurface(18)
    }
}

struct KitDetailSheet: View {
    let item: KitItem
    @EnvironmentObject var loc: LocalizationManager
    @EnvironmentObject var fan: FanStore

    private var inBag: Bool { fan.isInBag(item) }

    var body: some View {
        ZStack {
            Brand.page.ignoresSafeArea()
            VStack(spacing: 18) {
                Capsule().fill(Brand.navyLine).frame(width: 40, height: 5).padding(.top, 10)
                ZStack {
                    Circle().fill(Brand.blueGrad).frame(width: 220, height: 220)
                        .neonGlow(Brand.royal, radius: 24)
                    Image(item.image).resizable().scaledToFit()
                        .frame(width: 200, height: 200)
                }
                .padding(.top, 8)

                Text(loc.kitName(item))
                    .font(.display(24, .black))
                    .foregroundStyle(Brand.textHi)
                Text(loc.kitDetail(item))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Brand.textLo)
                Text(item.price)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.gold)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        fan.toggleBag(item)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: inBag ? "checkmark.circle.fill" : "cart.fill")
                        Text(inBag ? loc.t(.inBag) : loc.t(.addToBag))
                    }
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(Brand.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(inBag ? AnyShapeStyle(Brand.goldGrad)
                                                     : AnyShapeStyle(Brand.limeGrad)))
                    .neonGlow(inBag ? Brand.gold : Brand.neon, radius: 12)
                }
                .buttonStyle(PressStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
            .readableWidth(560)
        }
    }
}
