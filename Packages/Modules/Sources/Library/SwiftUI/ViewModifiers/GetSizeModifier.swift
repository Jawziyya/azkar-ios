import SwiftUI

public extension View {
    func getViewBoundsGeometry(
        _ geometryProxy: @escaping ((GeometryProxy) -> Void)
    ) -> some View {
        modifier(GetGeometryModifier(proxy: geometryProxy))
    }
}

public struct GetGeometryModifier: ViewModifier {
    let proxy: (GeometryProxy) -> Void

    public init(
        proxy: @escaping (GeometryProxy) -> Void
    ) {
        self.proxy = proxy
    }

    public func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    self.proxy(proxy)
                }
                return Color.clear
            }
        )
    }
}
