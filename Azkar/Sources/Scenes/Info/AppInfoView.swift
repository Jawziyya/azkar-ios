//
//  AppInfoView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Introspect
import SwiftUIX
import ActivityView

struct AppInfoView: View {

    typealias ItemSection = AppInfoViewModel.Section

    @ObservedObject var viewModel: AppInfoViewModel

    @State private var url: URL?
    @State private var activityItem: ActivityItem?

    var body: some View {
        Form {
            self.iconAndVersion.background(
                Color.background.padding(-20)
            )

            ForEach(viewModel.sections) { section in
                Section(header: Text(section.header ?? ""), footer: Text(section.footer ?? "")) {
                    ForEach(section.items) { item in
                        self.viewForItem(item)
                    }
                }
            }
            .listRowBackground(Color.contentBackground)
            .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button(action: {
                    activityItem = ActivityItem(items: URL(string: "https://itunes.apple.com/app/id1511423586")!)
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color.accent)
                })
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .navigationTitle(Text("about.title", comment: "About app screen title."))
        .supportedOrientations(.portrait)
        .activitySheet($activityItem)
        .sheet(item: $url) { url in
            SafariView(url: url, entersReaderIfAvailable: false)
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    private var iconAndVersion: some View {
        VStack {
            HStack {
                Spacer()
                Image(uiImage: UIImage(named: viewModel.iconImageName)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 1)
                    .id(viewModel.iconImageName)
                    .transition(.opacity)
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
        .introspectTableViewCell { cell in
            viewModel.presentationSources[item.id] = cell
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
    }

}

struct LegalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView(viewModel: AppInfoViewModel(preferences: Preferences.shared))
            .colorScheme(.dark)
    }
}
