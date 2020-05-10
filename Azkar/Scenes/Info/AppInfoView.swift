//
//  AppInfoView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct AppInfoView: View {

    typealias ItemSection = AppInfoViewModel.Section

    let viewModel: AppInfoViewModel
    let groupBackgroundElementID = UUID().uuidString

    @State private var url: URL?

    var body: some View {
        Form {
            self.iconAndVersion.background(
                Color(.systemGroupedBackground)
                    .padding(-20)
            )

            Section(header: Text(viewModel.legalInfoHeader)) {
                ForEach(viewModel.azkarLegalInfoModels, id: \.title) { item in
                    self.viewForItem(item)
                }
            }

            Section(header: Text(viewModel.imagesInfoHeader)) {
                ForEach(viewModel.imagesLegalInfoModels, id: \.title) { item in
                    self.viewForItem(item)
                }
            }

            Section(header: Text(viewModel.supportHeader)) {
                ForEach(viewModel.supportModels, id: \.title) { item in
                    self.viewForItem(item)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .navigationBarTitle(Text("О приложении"), displayMode: .inline)
//        .background(Color.background.edgesIgnoringSafeArea(.all))
        .supportedOrientations(.portrait)
        .sheet(item: $url) { url in
            SafariView(url: url, entersReaderIfAvailable: false)
        }
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
                    Text("Azkar")
                        .font(Font.headline.smallCaps().weight(.heavy))
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
            } else {
                UIApplication.shared.open(item.url)
            }
        }, label: {
            HStack {
                item.imageName.flatMap { name in
                    Image(uiImage: UIImage(named: name)!)
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
            .background(Color(.secondarySystemGroupedBackground))
        })
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
    }

}

struct LegalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView(viewModel: AppInfoViewModel())
            .colorScheme(.dark)
    }
}
