// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import NukeUI
import Nuke

struct FontsView: View {
    
    @StateObject var viewModel: FontsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var previewFont: AppFontViewModel?
    @State private var showArabicVowelsInfo = false
    
    var body: some View {
        List {
            ForEach(viewModel.fonts) { section in
                Section(header: Text(section.type.title)) {
                    ForEach(section.fonts) { font in
                        fontView(font)
                            .onTapGesture {
                                viewModel.changeSelectedFont(font)
                                UISelectionFeedbackGenerator().selectionChanged()
                            }
                    }
                }
            }
            .redacted(reason: viewModel.didLoadData ? [] : .placeholder)
            .listRowBackground(Color.contentBackground)
        }
        .listStyle(InsetGroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .horizontalPaddingForLargeScreen()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear(perform: viewModel.loadData)
        .navigationTitle(L10n.Fonts.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.fontsType == .arabic {
                    Button(action: {
                        self.showArabicVowelsInfo = true
                    }) {
                        Image(systemName: "info")
                    }
                }
            }
        }
        .sheet(item: $previewFont) { font in
            VStack {
                Text(font.name)
                    .font(Font.system(.largeTitle, design: .rounded))
                Spacer()
                
                if let imageURL = font.imageURL {
                    FontsListItemView.fontImageView(imageURL, isRedacted: false)
                        .foregroundColor(Color.text)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.background)
        }
        .sheet(isPresented: $showArabicVowelsInfo) {
            VStack {
                Text(L10n.Fonts.Arabic.info)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.background)
        }
    }
    
    func fontView(_ vm: AppFontViewModel) -> some View {
        FontsListItemView(
            vm: vm,
            isArabicFontsType: viewModel.fontsType == .arabic,
            isLoadingFont: viewModel.loadingFonts.contains(vm.id),
            isSelectedFont: viewModel.preferredFont.id == vm.font.id,
            selectionCallback: {
                self.previewFont = vm
            },
            isRedacted: !viewModel.didLoadData
        )
    }
    
}

struct FontsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FontsView(viewModel: .placeholder)
        }
        .preferredColorScheme(.light)
    }
}
