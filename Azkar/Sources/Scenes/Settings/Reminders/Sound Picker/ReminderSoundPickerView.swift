import SwiftUI
import Library

struct HeaderView: View {
    let title: String
    var body: some View {
        Text(title)
            .systemFont(.title3, modification: .smallCaps)
            .foregroundStyle(Color.secondaryText)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
    }
}

struct ReminderSoundPickerView: View {
    
    @ObservedObject var viewModel: ReminderSoundPickerViewModel
    @Environment(\.appTheme) var appTheme
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.sections) { section in
                VStack(spacing: 0) {
                    HeaderView(title: section.title)
                    
                    VStack {
                        ForEachIndexed(section.sounds) { _, position, sound in
                            soundView(sound)
                                .onTapGesture {
                                    DispatchQueue.main.async {
                                        viewModel.playSound(sound)
                                        viewModel.setPreferredSound(sound)
                                    }
                                }
                            if position != .last {
                                Divider()
                            }
                        }
                    }
                    .applyContainerStyle()
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .customScrollContentBackground()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(L10n.Settings.Reminders.Sounds.sound)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    private func soundView(_ sound: ReminderSound) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text(sound.title)
                .multilineTextAlignment(.leading)
                .systemFont(.body)
            
            Spacer()

            if viewModel.hasAccessToSound(sound) || viewModel.preferredSound == sound {
                CheckboxView(isCheked: .constant(viewModel.preferredSound == sound))
                    .frame(width: 20, height: 20)
            } else {
                ProBadgeView()
            }
        }
        .contentShape(Rectangle())
        .frame(minHeight: 44)
    }
    
}

#Preview("Reminder Sound Picker") {
    ReminderSoundPickerView(viewModel: .placeholder)
}
