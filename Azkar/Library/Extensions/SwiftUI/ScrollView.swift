//
//
//  Azkar
//  
//  Created on 13.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import SwiftUI

extension ScrollView {

    private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>

    func fixFlickering() -> some View {
        GeometryReader { geo in
            ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
                content.padding(geo.safeAreaInsets) as! PaddedContent
            }
            .edgesIgnoringSafeArea(.all)
        }
    }

}
