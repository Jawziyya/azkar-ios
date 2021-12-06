// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

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
        .listStyle(InsetGroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(L10n.Settings.Reminders.Sounds.sound)
        .navigationBarTitleDisplayMode(.inline)
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

struct ReminderSoundPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderSoundPickerView(viewModel: .placeholder)
    }
}
