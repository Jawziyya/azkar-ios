import SwiftUI
import Library

struct ReminderSoundPickerView: View {
    
    @ObservedObject var viewModel: ReminderSoundPickerViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.sounds) { sound in
                        soundView(sound)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    viewModel.playSound(sound)
                                    viewModel.setPreferredSound(sound)
                                }
                            }
                    }
                }
            }
            .listRowBackground(Color.contentBackground)
        }
        .listStyle(.insetGrouped)
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
                .font(Font.system(.body, design: .rounded))
            
            Spacer()

            CheckboxView(isCheked: .constant(viewModel.preferredSound == sound))
                .frame(width: 20, height: 20)
        }
        .contentShape(Rectangle())
        .frame(minHeight: 44)
    }
    
}

#Preview("Reminder Sound Picker") {
    ReminderSoundPickerView(viewModel: .placeholder)
}
