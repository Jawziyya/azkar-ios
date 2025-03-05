//
//  AzkarListView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 06.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer

typealias AzkarListViewModel = ZikrPagesViewModel

struct AzkarListView: View {

    let viewModel: AzkarListViewModel
    
    @State var page = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            list
        }
        .onAppear {
            AnalyticsReporter.reportScreen("Azkar List", className: viewName)
        }
        .navigationTitle(viewModel.title)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onReceive(viewModel.selectedPage) { page in
            self.page = page
        }
    }

    var list: some View {
        LazyVStack(alignment: HorizontalAlignment.leading, spacing: 8) {
            ForEach(viewModel.azkar.indices, id: \.self) { index in
                Button {
                    self.viewModel.navigateToZikr(viewModel.azkar[index], index: index)
                } label: {
                    HStack {
                        Text(viewModel.azkar[index].title ?? index.description)
                            .contentShape(Rectangle())
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

}

struct AzkarListView_Previews: PreviewProvider {
    static var previews: some View {
        AzkarListView(viewModel: .placeholder)
    }
}
