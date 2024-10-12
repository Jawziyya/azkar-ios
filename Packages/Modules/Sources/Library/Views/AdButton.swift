import SwiftUI
import NukeUI
import Entities
import Extensions

public struct AdButton: View {

    let item: AdButtonItem
    let onClose: () -> Void
    let action: () -> Void
    let cornerRadius: CGFloat
    
    public init(
        item: AdButtonItem,
        cornerRadius: CGFloat = 30,
        onClose: @escaping () -> Void,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.cornerRadius = cornerRadius
        self.onClose = onClose
        self.action = action
    }

    // The color used for the text will automatically switch to white if a background image is specified
    private var effectiveForegroundColor: Color {
        item.imageLink != nil ? .white : item.foregroundColor
    }
    
    private var size: AdSize { item.size }
    private var backgroundColor: Color { item.backgroundColor }
    private var accentColor: Color { item.accentColor }

    public var body: some View {
        HStack(alignment: .bottom, spacing: size.scale * 10) {
            VStack(alignment: .leading, spacing: size.scale * 20) {
                if let title = item.title {
                    Text(title)
                        .foregroundColor(effectiveForegroundColor)
                        .font(size.titleFont)
                }
                
                if let subtitle = item.body {
                    Text(subtitle)
                        .foregroundColor(effectiveForegroundColor)
                        .font(size.bodyFont)
                }
            }
            
            Spacer()
            
            if let actionTitle = item.actionTitle {
                actionButton(actionTitle)
            }
        }
        .padding(.vertical, 25 * size.scale)
        .padding(.horizontal, 25 * size.scale)
        .onTapGesture(perform: action)
        .overlay(alignment: .topTrailing) {
            GeometryReader { geometry in
                VStack(alignment: .trailing) {
                    closeButton
                    
                    Spacer()
                    
                    if item.actionTitle == nil {
                        Image(systemName: "arrow.up.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.scale * 10, height: size.scale * 10)
                            .foregroundColor(item.foregroundColor.opacity(0.5))
                            .padding(size.scale * 10)
                            .clipShape(Circle())
                            .contentShape(Rectangle())
                    }
                }
                .padding([.trailing, .vertical], 20 * size.scale)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .trailing)
            }
        }
        .background(
            ZStack {
                backgroundColor
                if let imageLink = item.imageLink {
                    backgroundImageView(for: imageLink)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(accentColor, lineWidth: 2 * size.scale)
        )
    }
    
    private var closeButton: some View {
        Image(systemName: "xmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.scale * 10, height: size.scale * 10)
            .foregroundColor(Color.white)
            .padding(size.scale * 10)
            .background(item.accentColor.opacity(0.25))
            .clipShape(Circle())
            .contentShape(Rectangle())
            .highPriorityGesture(
                TapGesture()
                    .onEnded(onClose)
            )
    }
    
    private func actionButton(_ title: String) -> some View {
        Text(title)
            .font(size.actionFont)
            .foregroundStyle(Color.white)
            .shadow(color: item.accentColor.opacity(0.5), radius: 10, x: 0, y: 5)
            .padding(size.scale * 10)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(item.accentColor)
            }
    }

    @ViewBuilder
    private func backgroundImageView(for url: URL) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(Color.black.opacity(0.35))
            }
        }
    }
}

#Preview("Telegram Bot") {
    return AdButton(
        item: AdButtonItem(ad: .telegramBotDemo),
        onClose: {},
        action: {}
    )
}

@available(iOS 17, *)
#Preview("Tickets. Minimal", traits: .fixedLayout(width: 350, height: 200)) {
    return AdButton(
        item: AdButtonItem(ad: .ticketsDemo),
        onClose: {},
        action: {}
    )
    .padding()
}

@available(iOS 17, *)
#Preview("Find Hotel. Minimal", traits: .fixedLayout(width: 350, height: 200)) {
    return AdButton(
        item: AdButtonItem(ad: .hotelsDemo),
        onClose: {},
        action: {}
    )
    .padding()
}
