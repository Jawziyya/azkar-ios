import SwiftUI
import SafariServices

public final class SafariPresenterModel: ObservableObject {
    static let shared = SafariPresenterModel()
    
    @Published var urlToOpen: URL?
    
    public func set(_ url: URL?) {
        self.urlToOpen = url
    }
}

public struct SafariPresenterKey: EnvironmentKey {
    public static let defaultValue = SafariPresenterModel.shared
}

extension EnvironmentValues {
    public var safariPresenter: SafariPresenterModel {
        get { self[SafariPresenterKey.self] }
        set { self[SafariPresenterKey.self] = newValue }
    }
}

public struct SafariPresenter: ViewModifier {
    @StateObject var model = SafariPresenterModel.shared
    @State private var showSafari = false
    
    public func body(content: Content) -> some View {
        content
            .onReceive(model.$urlToOpen) { url in
                guard let url = url else { return }
                
                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { completed in
                    if !completed {
                        showSafari = true
                    }
                }
            }
            .sheet(isPresented: $showSafari) {
                if let url = model.urlToOpen {
                    SafariView(url: url)
                }
            }
    }
}

extension View {
    public func attachSafariPresenter() -> some View {
        self.modifier(SafariPresenter())
    }
}

public struct SafariView: UIViewControllerRepresentable {
    let url: URL
    var entersReaderIfAvailable = false
    var preferredTintColor: Color?
    
    public init(
        url: URL,
        entersReaderIfAvailable: Bool = false,
        preferredTintColor: Color? = nil
    ) {
        self.url = url
        self.entersReaderIfAvailable = entersReaderIfAvailable
        self.preferredTintColor = preferredTintColor
    }

    // MARK: - Representable
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = entersReaderIfAvailable
        let safari = SFSafariViewController(url: url, configuration: configuration)
        if let preferredTintColor {
            safari.preferredControlTintColor = UIColor(preferredTintColor)
        }
        return safari
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

// MARK: - Preview
struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://google.com/")!
        return SafariView(url: url, entersReaderIfAvailable: false)
    }
}
