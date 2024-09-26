//  Copyright © 2020 Al Jawziyya. All rights reserved.

import UIKit
import SwiftUI
import SwiftUIIntrospect
import SwiftUIX
import SwiftUIBackports

struct AppInfoView: View {

    typealias ItemSection = AppInfoViewModel.Section

    @ObservedObject var viewModel: AppInfoViewModel


    @State private var activityItem: URL?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0) {
                self.iconAndVersion.background(
                    Color.background.padding(-20)
                )
                .padding()
                
                ForEach(viewModel.sections, content: sectionView)
                    .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
            }
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Backport.ShareLink(item: URL(string: "https://apps.apple.com/app/id1511423586")!) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color.accent)
                }
            }
        }
        .navigationTitle(Text("about.title", comment: "About app screen title."))
        .supportedOrientations(.portrait)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    private var iconAndVersion: some View {
        VStack {
            HStack {
                Spacer()
                if let image = UIImage(named: viewModel.iconImageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 1)
                        .id(viewModel.iconImageName)
                        .transition(.opacity)
                }
                Spacer()
            }

            HStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("app-name", comment: "App name.")
                            .font(Font.system(.title2, design: .rounded).smallCaps().weight(.heavy))
                            .frame(alignment: .center)
                            .foregroundColor(Color.accent)
                        if !UIDevice.current.isMac, viewModel.subscriptionManager.isProUser() {
                            Text(" PRO")
                                .font(Font.system(.title3, design: .rounded).smallCaps().weight(.heavy))
                                .foregroundColor(Color.blue)
                        }
                    }
                    
                    Text(viewModel.appVersion)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
                Spacer()
            }
        }
    }
    
    private func sectionView(_ section: ItemSection) -> some View {
        NavigationLink {
            sectionItemsView(section)
        } label: {
            sectionHeader(section)
        }
    }
    
    private func sectionHeader(_ section: ItemSection) -> some View {
        HStack {
            Text(section.title)
                .foregroundStyle(Color.text)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.accent)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func sectionItemsView(_ section: ItemSection) -> some View {
        List(section.items) { item in
            viewForItem(item)
                .listRowBackground(Color.contentBackground)
        }
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .listStyle(.grouped)
        .navigationBarTitle(section.title)
    }

    private func viewForItem(_ item: SourceInfo.Item) -> some View {
        Button(action: {
            if let url = URL(string: item.link) {
                UIApplication.shared.open(url)
            }
        }, label: {
            HStack {
                Text(item.title)
                    .foregroundColor(Color.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.tertiaryText)
            }
            .background(Color.contentBackground)
            .clipShape(Rectangle())
        })
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

}

#Preview("App Info") {
    NavigationView {
        AppInfoView(viewModel: AppInfoViewModel(preferences: Preferences.shared))
    }
}
