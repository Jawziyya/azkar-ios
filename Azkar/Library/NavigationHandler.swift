//
//
//  Azkar
//  
//  Created on 04.05.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import SwiftUI
import Combine

enum NavigationDirection {
    case back
    case forward(destination: NavigationDestination, style: NavigationStyle)
}

enum NavigationDestination {
    case zikr(viewModel: ZikrViewModel, showTitle: Bool? = .none)
    case category(ZikrPagesViewModel)
    case about(preferences: Preferences)
    case settings(SettingsViewModel)
}

enum NavigationStyle {
    case push(isDetail: Bool = true)
    case present
}

protocol Navigable {
    var navigationPublisher: AnyPublisher<NavigationDirection, Never> { get }
}

struct ViewFactory {
    private var isIpad: Bool {
        UIDevice.current.isIpad
    }

    func makeView(destination: NavigationDestination) -> some View {
        ZStack {
            switch destination {
            case .category(let vm):
                getZikrList(vm)
            case .zikr(let vm, let showTitle):
                ZikrView(viewModel: vm, showTitle: showTitle)
            case .about(let preferences):
                AppInfoView(viewModel: AppInfoViewModel(prerences: preferences))
            case .settings(let viewModel):
                SettingsView(viewModel: viewModel)
            }
        }
    }

    @ViewBuilder
    private func getZikrList(_ viewModel: ZikrPagesViewModel) -> some View {
        if isIpad {
            AzkarListView(viewModel: viewModel)
        } else {
            ZStack {
                switch viewModel.category {
                case .morning, .evening, .afterSalah:
                    ZikrPagesView(viewModel: viewModel)
                        .navigationBarTitle("", displayMode: .inline)
                case .other:
                    AzkarListView(viewModel: viewModel)
                }
            }
        }
    }

}

struct Router {
    static var shared = Router()
    private init() {}

    private let navigationSubject = PassthroughSubject<NavigationDirection, Never>()

    var navigationPublisher: AnyPublisher<NavigationDirection, Never> {
        navigationSubject
            .receive(on: RunLoop.main)
            .share()
            .eraseToAnyPublisher()
    }

    func navigateBack() {
        navigationSubject.send(.back)
    }

    func push(_ destionation: NavigationDestination, isDetailLink: Bool = true) {
        navigationSubject.send(.forward(destination: destionation, style: .push(isDetail: isDetailLink)))
    }

    func present(_ destination: NavigationDestination) {
        navigationSubject.send(.forward(destination: destination, style: .present))
    }
}

struct NavigationHandler: ViewModifier {
    let navigationPublisher: AnyPublisher<NavigationDirection, Never>
    @State private var destination: NavigationDestination?
    @State private var sheetActive = false
    @State private var linkActive = false
    @State private var linkIsDetail = true
    @Environment(\.presentationMode) var presentation
    let viewFactory: ViewFactory = ViewFactory()
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $sheetActive) {
                buildDestination()
            }
            .background(
                NavigationLink(destination: buildDestination(), isActive: $linkActive) {
                    EmptyView()
                }
                .isDetailLink(linkIsDetail)
            )
            .onReceive(navigationPublisher) { direction in
                guard presentation.wrappedValue.isPresented else {
                    return
                }

                switch direction {
                case .forward(let destination, let style):
                    self.destination = destination
                    switch style {
                    case .present:
                        sheetActive = true
                    case .push(let isDetail):
                        linkIsDetail = isDetail
                        linkActive = true
                    }
                case .back:
                    linkActive = false
                    linkIsDetail = false
                    presentation.wrappedValue.dismiss()
                }
            }
    }

    @ViewBuilder
    private func buildDestination() -> some View {
        if let destination = destination {
            viewFactory.makeView(destination: destination)
        } else {
            EmptyView()
        }
    }
}

extension View {
    func handleNavigation(_ publisher: AnyPublisher<NavigationDirection, Never>) -> some View {
        self.modifier(NavigationHandler(navigationPublisher: publisher))
    }
}
