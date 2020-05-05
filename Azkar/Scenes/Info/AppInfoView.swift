//
//  AppInfoView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct AppInfoView: View {

    typealias ItemSection = AppInfoViewModel.Section

    let viewModel: AppInfoViewModel
    let groupBackgroundElementID = UUID().uuidString

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

        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .environment(\.verticalSizeClass, .regular)
        .navigationBarTitle(Text("О приложении"), displayMode: .inline)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .supportedOrientations(.portrait)
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

    private var remindersStyleMenu: some View {
        ASCollectionView {
            sections
        }
        .layout(menuLayout)
        .contentInsets(.init(top: 20, left: 0, bottom: 20, right: 0))
        .alwaysBounceVertical()
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }

    private var sections: [ASCollectionViewSection<ItemSection>] {
        return [
            
        ASCollectionViewSection<ItemSection>(id: .versionAndName) {
            self.iconAndVersion
        },

        ASCollectionViewSection<ItemSection>(id: .azkarLegal, data: viewModel.azkarLegalInfoModels) { item, ctx in
            VStack {
                Spacer()
                self.viewForItem(item)
                if !ctx.isLastInSection {
                    Divider()
                }
                Spacer()
            }
        }
        .sectionHeader {
            Text(viewModel.legalInfoHeader)
                .font(Font.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        },

        ASCollectionViewSection<ItemSection>(id: .imagesLegal, data: viewModel.imagesLegalInfoModels) { item, ctx in
            VStack {
                Spacer()
                self.viewForItem(item)
                if !ctx.isLastInSection {
                    Divider()
                }
                Spacer()
            }
        }
        .sectionHeader {
            Text(viewModel.imagesInfoHeader)
                .font(Font.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        },

        ]
    }

    private func viewForItem(_ item: SourceInfo) -> some View {
        Button(action: {
            UIApplication.shared.open(item.url)
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
                    .foregroundColor(Color.init(.link))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.tertiaryText)
            }
        })
        .padding(.vertical, 8)
    }

    private var menuLayout: ASCollectionLayout<ItemSection> {
        ASCollectionLayout<ItemSection>(interSectionSpacing: 20) { sectionID in
            switch sectionID {

            case .versionAndName:
                return .grid(
                    layoutMode: .fixedNumberOfColumns(1),
                    itemSpacing: 0,
                    lineSpacing: 0,
                    itemSize: .estimated(100)
                )

            case .azkarLegal, .imagesLegal:
                return ASCollectionLayoutSection {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(40))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(40))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

                    let supplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
                    let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: supplementarySize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                    let footerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: supplementarySize,
                        elementKind: UICollectionView.elementKindSectionFooter,
                        alignment: .bottom)
                    section.boundarySupplementaryItems = [headerSupplementary, footerSupplementary]

                    let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: self.groupBackgroundElementID)
                    sectionBackgroundDecoration.contentInsets = section.contentInsets
                    section.decorationItems = [sectionBackgroundDecoration]

                    return section
                }
            }
        }
        .decorationView(GroupBackground.self, forDecorationViewOfKind: groupBackgroundElementID)
    }

}

struct LegalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView(viewModel: .init())
            .colorScheme(.dark)
    }
}
