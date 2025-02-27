import SwiftUI

extension View {
    
    var viewName: String {
        String(describing: type(of: self))
    }
    
    static var viewName: String {
        String(describing: self)
    }
    
}
