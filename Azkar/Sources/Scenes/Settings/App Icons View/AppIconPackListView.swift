//
//
//  Azkar
//  
//  Created on 13.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import SwiftUI
import Combine

final class AppIconPackListViewModel: ObservableObject {

    var preferences: Preferences

    @Published var icon: AppIcon
    let iconPacks: [AppIconPack] = AppIconPack.allCases

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences) {
        self.preferences = preferences
        icon = preferences.appIcon

        $icon
            .dropFirst(1)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { icon in
                preferences.appIcon = icon
                switch icon {
                case .gold:
                    // Reset to standard icon.
                    UIApplication.shared.setAlternateIconName(nil)
                default:
                    // Apply custom icon.
                    UIApplication.shared.setAlternateIconName(icon.referenceName)
                }
            })
            .store(in: &cancellabels)
    }

    func isPackPurchased(_ pack: AppIconPack) -> Bool {
        if UIApplication.shared.isRanInSimulator {
            return true
        } else {
            return preferences.purchasedIconPacks.contains(pack)
        }
    }

}

struct AppIconPackListView: View {

    @ObservedObject var viewModel: AppIconPackListViewModel

    init(viewModel: AppIconPackListViewModel) {
        self.viewModel = viewModel
    }

    @State private var selectedIconPack: AppIconPackInfoViewModel?
    @State private var modalOffset: CGFloat = 0
    @State private var selectedURL: URL?
    @State private var safariViewURL: URL?
    @State private var moveEdge = Edge.bottom

    private var animation = Animation.spring().speed(1.25)

    var body: some View {
        ZStack {
            list

            if let pack = selectedIconPack {
                Group {
                    Color.black.opacity(0.75)
                        .onTapGesture {
                            self.closeIconPackInfoWithAnimation()
                        }
                        .edgesIgnoringSafeArea(.all)

                    AppIconPackInfoView(viewModel: pack)
                        .padding()
                        .offset(y: modalOffset)
                        .transition(AnyTransition.move(edge: moveEdge).combined(with: .opacity))
                        .zIndex(1)
                        .frame(maxWidth: 400)
                }
                .gesture(
                    DragGesture().onChanged { action in
                        self.modalOffset = action.translation.height
                        self.moveEdge = (action.translation.height < 0) ? Edge.top : Edge.bottom
                        if abs(action.translation.height) > 200 || abs(action.predictedEndTranslation.height) > 500 {
                            self.closeIconPackInfoWithAnimation()
                        }
                    }
                    .onEnded { action in
                        withAnimation(self.animation) {
                            if abs(action.translation.height) <= 200 {
                                self.modalOffset = 0
                                self.selectedIconPack = nil
                            }
                        }
                    }
                )
            }
        }
        .onChange(of: selectedURL) { url in
            if let url = url {
                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { flag in
                    if !flag {
                        self.safariViewURL = url
                    }
                }
                self.selectedURL = nil
            }
        }
        .sheet(item: $safariViewURL) { url in
            SafariView(url: url, entersReaderIfAvailable: false)
        }
    }

    private func closeIconPackInfoWithAnimation() {
        withAnimation(animation) {
            self.selectedIconPack = nil
            self.modalOffset = 0
        }
    }

    var list: some View {
        List {
            ForEach(viewModel.iconPacks) { pack in
                iconPicker(pack)
            }
            .listRowBackground(Color.contentBackground)
        }
        .listStyle(InsetGroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    func iconPicker(_ iconPack: AppIconPack) -> some View {
        Section(
            header:
                VStack(spacing: 0) {
                    Spacer(minLength: 8)
                    HStack {
                        Text(iconPack.title)
                            .font(Font.system(.caption, design: .rounded))
                        Spacer()

                        iconPack.link.flatMap { link in
                            Button(action: {
                                self.selectedURL = link
                            }, label: {
                                Image(systemName: "link")
                            })
                        }
                    }
                }
            ,
            content: {
                self.content(for: iconPack)
            })
    }

    func content(for pack: AppIconPack) -> some View {
        ForEach(pack.icons) { icon in
            HStack(spacing: 16) {
                Image(uiImage: UIImage(named: icon.imageName)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 1)

                Text(icon.title)
                    .font(Font.system(.body, design: .rounded))
                Spacer()
                CheckboxView(isCheked:  .constant(self.viewModel.icon.referenceName == icon.referenceName))
                    .frame(width: 20, height: 20)
            }
            .contentShape(Rectangle())
            .padding(.vertical, 10)
            .onTapGesture {
                DispatchQueue.main.async {
                    guard self.viewModel.isPackPurchased(pack) else {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        withAnimation(.spring()) {
                            self.selectedIconPack = AppIconPackInfoViewModel(preferences: self.viewModel.preferences, pack: pack, icon: icon, closeAction: {
                                self.closeIconPackInfoWithAnimation()
                            }, successAction: {
                                self.viewModel.preferences.purchasedIconPacks.append(pack)
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.closeIconPackInfoWithAnimation()
                                    self.viewModel.icon = icon
                                }
                            })
                        }
                        return
                    }

                    if icon != self.viewModel.icon {
                        self.viewModel.icon = icon
                        UISelectionFeedbackGenerator().selectionChanged()
                    }
                }
            }
        }
    }

}

struct AppIconPackListView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPackListView(viewModel: AppIconPackListViewModel(preferences: Preferences()))
    }
}
