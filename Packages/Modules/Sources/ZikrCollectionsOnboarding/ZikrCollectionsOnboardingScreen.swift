import SwiftUI

struct ZikrCollectionsOnboardingScreen: View {
        
    let onShowCollectionPicker: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ScrollView {
            content
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.tertiaryText)
                }
                .opacity(0.5)
                .buttonStyle(.plain)
                .padding()                
            }
        }
    }
            
    var content: some View {
        VStack(spacing: 31) {
            Color.clear.frame(height: 20)
            
            headerImage
                .frame(width: 200, height: 200)

            Text(L10n.AdhkarCollections.Onboarding.title)
                .font(Font.title.weight(.semibold))
                .multilineTextAlignment(.center)
            
            items
            
            mainActionButton
        }
        .frame(maxWidth: .infinity)
    }
    
    var headerImage: some View {
        Image("ZikrCollectionsOnboarding/header")
    }
    
    var mainActionButton: some View {
        Button(action: {
            onShowCollectionPicker()
        }) {
            Text(L10n.Common.continue)
                .font(Font.body.weight(.semibold))
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    var items: some View {
        VStack(spacing: 21) {
            itemView(
                imageName: "confetti",
                text: L10n.AdhkarCollections.Onboarding.step1
            )
            
            itemView(
                imageName: "paper-and-magnifier",
                text: L10n.AdhkarCollections.Onboarding.step2
            )
            
            itemView(
                imageName: "card-file-box",
                text: L10n.AdhkarCollections.Onboarding.step3
            )
        }
    }
    
    func itemView(
        imageName: String,
        text: String
    ) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Image("ZikrCollectionsOnboarding/" + imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    ZikrCollectionsOnboardingScreen(onShowCollectionPicker: {}, onDismiss: {})
}
