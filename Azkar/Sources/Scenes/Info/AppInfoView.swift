//
//  AppInfoView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Introspect

struct AppInfoView: View {

    typealias ItemSection = AppInfoViewModel.Section

    let viewModel: AppInfoViewModel

    @State private var url: URL?

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
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .navigationTitle(Text("about.title", comment: "About app screen title."))
        .supportedOrientations(.portrait)
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
                Spacer()
            }

            HStack {
                Spacer()
                VStack(spacing: 0) {
                    Text("app-name", comment: "App name.")
                        .font(Font.system(.headline, design: .rounded).smallCaps().weight(.heavy))
                        .frame(alignment: .center)
                        .foregroundColor(Color.accent)
                    Text(viewModel.appVersion)
                        .font(.subheadline)
                        .foregroundColor(Color.accent.opacity(0.5))
                }
                Spacer()
            }
        }
    }

    private func viewForItem(_ item: SourceInfo) -> some View {
        Button(action: {
            if item.openUrlInApp {
                self.url = item.url
            } else if let url = item.url {
                UIApplication.shared.open(url)
            } else if let action = item.action {
                action()
            }
        }, label: {
            HStack {
                item.imageName.flatMap { name in
                    (item.imageType == .bundled ? Image(uiImage: UIImage(named: name)!) : Image(systemName: name))
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1)
                }
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
        AppInfoView(viewModel: AppInfoViewModel(preferences: Preferences()))
            .colorScheme(.dark)
    }
}
