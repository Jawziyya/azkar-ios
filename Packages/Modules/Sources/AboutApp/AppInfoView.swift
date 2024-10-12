//  Copyright © 2020 Al Jawziyya. All rights reserved.

import UIKit
import SwiftUI
import SwiftUIIntrospect
import SwiftUIBackports
import Library

public struct AppInfoView: View {

    @ObservedObject var viewModel: AppInfoViewModel
    @State private var activityItem: URL?
    
    public init(viewModel: AppInfoViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0) {
                self.iconAndVersion.background(
                    Color.background.padding(-20)
                )
                .padding()
                
                outboundLink(
                    "credits.studio.telegram-channel",
                    url: URL(string: "https://jawziyya.t.me")!,
                    image: "paperplane",
                    color: Color.blue
                )
                
                outboundLink(
                    "credits.studio.instagram-page",
                    url: URL(string: "https://instagram.com/jawziyya.studio")!,
                    image: "photo.stack",
                    color: Color.orange
                )
                
                outboundLink(
                    "credits.studio.jawziyya-apps",
                    url: URL(string: "https://apps.apple.com/developer/al-jawziyya/id1165327318")!,
                    image: "apps.iphone",
                    color: Color.indigo
                )
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
        .customScrollContentBackground()
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
                        Text("app-name")
                            .font(Font.system(.title2, design: .rounded).smallCaps().weight(.heavy))
                            .frame(alignment: .center)
                            .foregroundColor(Color.accent)
                        if !UIDevice.current.isMac, viewModel.isProUser {
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
    
    private func outboundLink(
        _ title: LocalizedStringKey,
        url: URL,
        image: String,
        color: Color
    ) -> some View {
        Button {
            UIApplication.shared.open(url)
        } label: {
            HStack(spacing: 15) {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(color)
                
                Text(title)
                
                Spacer()
                
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(color)
                    .font(Font.caption2)
                    .opacity(0.5)
            }
            .padding()
            .background(Color.contentBackground)
        }
        .buttonStyle(.plain)
        .removeSaturationIfNeeded()
    }
    
}

#Preview("App Info") {
    NavigationView {
        AppInfoView(viewModel: AppInfoViewModel(
            appVersion: "1.2.3",
            isProUser: true
        ))
    }
}
