import SwiftUI

struct ReadingCompletionView: View {
    @State private var isCompleted: Bool
    @Environment(\.colorTheme) var colorTheme
    
    init(isCompleted: Bool) {
        _isCompleted = State(wrappedValue: isCompleted)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colorTheme.getColor(.contentBackground))
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                    .frame(width: 80, height: 80)
            }
            .opacity(isCompleted ? 1 : 0)
            
            if isCompleted {
                Text(L10n.ReadingCompletion.title)
                    .systemFont(.title, weight: .bold)
                
                Text(L10n.ReadingCompletion.subtitle)
                    .systemFont(.body)
                    .foregroundColor(.secondary)
            } else {
                Text(L10n.ReadingCompletion.trackYourProgress)
                    .systemFont(.body)
                    .foregroundColor(colorTheme.getColor(.secondaryText))
                    .padding(.horizontal)
                
                Button(action: {
                    isCompleted = true
                }) {
                    Text(L10n.ReadingCompletion.markAsCompleted)
                        .systemFont(.body, weight: .semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(colorTheme.getColor(.accent))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, 8)
            }
        }
        .padding(30)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
}

struct ReadingCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReadingCompletionView(isCompleted: false)
                .previewDisplayName("Not Completed")
            ReadingCompletionView(isCompleted: true)
                .previewDisplayName("Completed")
        }
        .previewLayout(.sizeThatFits)
    }
}
