// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import NukeUI
import Nuke
import Popovers

struct FontsView: View {
    
    @StateObject var viewModel: FontsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var previewFont: AppFontViewModel?
    
    var sampleTextView: some View {
        VStack {
            Divider()
            
            Text(viewModel.sampleText)
                .font(Font.custom(viewModel.preferredFont.postscriptName, size: UIFont.preferredFont(forTextStyle: .title1).pointSize))
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.contentBackground)
                        .shadow(color: Color.accentColor.opacity(0.25), radius: 10, x: 0, y: 0)
                )
                .padding()
        }
        .background(Color.background)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.fonts) { section in
                Section(header: Text(section.type.title)) {
                    ForEach(section.fonts) { font in
                        fontView(font)
                            .onTapGesture {
                                Task {
                                    await viewModel.changeSelectedFont(font)
                                }
                                UISelectionFeedbackGenerator().selectionChanged()
                            }
                    }
                }
            }
            .redacted(reason: viewModel.didLoadData ? [] : .placeholder)
            .listRowBackground(Color.contentBackground)
            
            sampleTextView
                .opacity(0)
                .listRowBackground(Color.clear)
        }
        .overlay(alignment: .bottom) {
            sampleTextView
        }
        .customScrollContentBackground()
        .listStyle(.insetGrouped)
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .onAppear(perform: viewModel.loadData)
        .navigationTitle(L10n.Fonts.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.fontsType == .arabic {
                    Templates.Menu {
                        Text(L10n.Fonts.Arabic.info)
                            .foregroundColor(Color.primary)
                            .padding()
                            .cornerRadius(10)
                    } label: { _ in
                        Image(systemName: "info")
                            .foregroundColor(Color.accent)
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
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
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
