// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

struct FontsView: View {
    
    @StateObject var viewModel: FontsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var previewFont: AppFontViewModel?
    
    var body: some View {
        List {
            ForEach(viewModel.fonts) { section in
                Section(section.type.title) {
                    ForEach(section.fonts) { font in
                        fontView(font)
                            .onTapGesture {
                                viewModel.changeSelectedFont(font)
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
        .navigationTitle("Шрифты")
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
        AsyncImage(url: url) { img in
            img
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ZStack {
                if viewModel.didLoadData {                
                    ActivityIndicator(style: .medium, color: Color.secondary)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
    
}

struct FontsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FontsView(viewModel: FontsViewModel(service: FontsService()))
        }
        .preferredColorScheme(.light)
    }
}
