//
//  ItemDetailView.swift
//  MoreControls
//
//  Created by Kiyong Kim on 1/16/24.
//

import SwiftUI

struct ItemDetailView: View {
    let name: String
    var body: some View {
        VStack {
            Image(systemName: "fan.desk")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text(name)
                .font(.largeTitle)
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//            NavigationView {
//                //        DetailView()
//            }
//    }
//}
#Preview {
    NavigationView {
        ItemDetailView(name: "HelloWorld")
    }
}
