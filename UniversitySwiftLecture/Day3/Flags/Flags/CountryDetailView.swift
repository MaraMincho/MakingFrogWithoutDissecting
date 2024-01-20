//
//  CountryDetailView.swift
//  Flags
//
//  Created by Kiyong Kim on 1/17/24.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country
    var body: some View {
        VStack {
            Image(country.file)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 100)
            Text(country.name)
            List {
                ForEach(0..<country.name.count, id: \.self) { idx in
                    let str = country.name.prefix(idx+1)
                    Text(str)
                }
            }
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        CountryDetailView(country: Region.all[0].countries[0])
    }
}

