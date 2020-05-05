//
//  LazyView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 05.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
