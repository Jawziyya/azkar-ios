// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import NukeUI
import Nuke

struct FontsView: View {
    
    @StateObject var viewModel: FontsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var previewFont: AppFontViewModel?
    
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
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear(perform: viewModel.loadData)
        .navigationTitle(L10n.Fonts.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $previewFont) { font in
            VStack {
                Text(font.name)
                    .font(Font.system(.largeTitle, design: .rounded))
                Spacer()
                
                if let imageURL = font.imageURL {
                    fontImageView(imageURL)
                        .foregroundColor(Color.text)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.background)
        }
    }
    
    func fontView(_ vm: AppFontViewModel) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text(vm.name)
                .multilineTextAlignment(.leading)
                .font(Font.customFont(vm.font.postscriptName, style: .body, sizeCategory: nil))
            
            if viewModel.loadingFonts.contains(vm.font) {
                ActivityIndicator(style: .medium, color: Color.text)
            }
            
            Spacer()
            
            if let imageURL = vm.imageURL {
                fontImageView(imageURL)
                    .frame(width: 100, height: 40)
                    .foregroundColor(Color.accent)
                    .onTapGesture {
                        previewFont = vm
                    }
            }
            
            CheckboxView(isCheked: .constant(viewModel.preferredFont == vm.font))
                .frame(width: 20, height: 20)
        }
        .contentShape(Rectangle())
        .frame(minHeight: 44)
    }
    
    func fontImageView(_ url: URL?) -> some View {
        LazyImage(source: url) { state in
            if let image = state.image {
                image
                    .resizingMode(.aspectFit)
                    .accentColor(Color.text)
            } else if state.error != nil {
                Color.clear
            } else {
                if viewModel.didLoadData {
                    ActivityIndicator(style: .medium, color: Color.secondary)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .processors([
            ImageProcessors.Anonymous(id: "rendering-mode") { image in
                image.withRenderingMode(.alwaysTemplate)
            }
        ])
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
