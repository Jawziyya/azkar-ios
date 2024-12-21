import SwiftUI
import Library

struct PickerView<T: View>: View {

    var label: String
    var navigationTitle: String?
    var titleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    var subtitle: String
    var destination: T

    var body: some View {
        NavigationLink(
            destination: destination.navigationBarTitle(navigationTitle ?? label, displayMode: titleDisplayMode)
        ) {
            NavigationLabel(
                title: label,
                label: subtitle
            )
        }
    }

}
