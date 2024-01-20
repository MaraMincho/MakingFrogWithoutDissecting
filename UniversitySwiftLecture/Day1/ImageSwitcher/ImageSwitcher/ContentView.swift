//
//  ContentView.swift
//  ImageSwitcher
//
//  Created by Kiyong Kim on 1/15/24.
//

import SwiftUI


struct TopButton: View {
    var isLeft: Bool
    var body: some View {
        Button {
            //page -= 1
        } label: {
            Image(systemName: 
                isLeft ?
                "arrow.left.circle.fill" :
                "arrow.right.circle.fill"
            )
        }
        .background(Color.yellow)
        .padding()
        .background(Color.blue)
        //.disabled(page == 1)
    }
}

struct ContentView: View {
    @State var page = 1
    let totalPage = 5
    var body: some View {
        VStack {
            HStack {
                TopButton(isLeft: true)
                Spacer()
                Text("\(page)/\(totalPage)")
                Spacer()
                TopButton(isLeft: false);
            }
            .font(.largeTitle)
            Image("cat\(page)")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

