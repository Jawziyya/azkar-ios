import SwiftUI
import Entities

struct ZikrCollectionsSelectionScreen: View {
    
    @State var selectedCollection: ZikrCollectionSource = .azkarRU
    let onContinue: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Color.clear.frame(height: 0)
                
                content
                
                note
                
                mainActionButton
            }
            .padding(.horizontal, 20)
        }
        .customScrollContentBackground()
        .background(Color.background)
        .navigationTitle(L10n.AdhkarCollections.selectionScreenTitle)
    }
    
    var mainActionButton: some View {
        Button(action: onContinue) {
            Text(L10n.Common.continue)
                .font(Font.body.weight(.semibold))
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    var content: some View {
        VStack(spacing: 21) {
            itemView(collection: .hisnulMuslim)
            itemView(collection: .azkarRU)
        }
    }
    
    func itemView(
        collection: ZikrCollectionSource
    ) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            withAnimation(.spring) {
                selectedCollection = collection
            }
        } label: {
            itemViewLabel(collection)
        }

    }
    
    func itemViewLabel(_ collection: ZikrCollectionSource) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(collection.title)
                    .font(Font.title3.bold())
                
                Spacer()
                
                Image(_systemName: "checkmark")
                    .foregroundStyle(Color.accentColor)
                    .opacity(collection == selectedCollection ? 1 : 0)
            }
            Text(collection.description)
        }
        .foregroundStyle(Color.primary)
        .multilineTextAlignment(.leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
        .background(Color.contentBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var note: some View {
        HStack(alignment: .top) {
            Image(systemName: "info.circle.fill")
            Text(L10n.AdhkarCollections.orderExplanationText)
        }
        .foregroundStyle(Color.secondaryText.opacity(0.5))
        .font(Font.caption2)
        .frame(maxWidth: .infinity)
    }
    
}

#Preview {
    NavigationView {
        ZikrCollectionsSelectionScreen(onContinue: {})
    }
}
