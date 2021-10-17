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
        .if(UIDevice.current.isIpadInterface) { v in
            v.fixFlickering()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onReceive(viewModel.selectedPage) { page in
            self.page = page
        }
    }

    var list: some View {
        LazyVStack(alignment: HorizontalAlignment.leading, spacing: 8) {
            ForEach(viewModel.azkar.indexed(), id: \.1) { index, vm in
                Button {
                    self.viewModel.navigateToZikr(vm, index: index)
                } label: {
                    HStack {
                        Text(vm.title)
                            .contentShape(Rectangle())
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .allowsHitTesting(page != index)
            }
        }
    }

}

struct AzkarListView_Previews: PreviewProvider {
    static var previews: some View {
        AzkarListView(viewModel: .placeholder)
    }
}
