//
//  ContentView.swift
//  Flags
//
//  Created by Kiyong Kim on 1/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(Region.all, id: \.title) { rgn in
                    Section(rgn.title) {
                        ForEach(rgn.countries, id: \.name) { cntr in
                            NavigationLink {
                                CountryDetailView(country: cntr)
                            } label: {
                                CountryItemView(country: cntr)
                            }
                        }
                    }
                }
            }
            .navigationTitle("AppStore Countries")
        }
    }
}

#Preview {
    ContentView()
}

struct CountryItemView: View {
    let country: Country
    var body: some View {
        HStack {
            Image(country.file)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
            VStack {
                Text(country.name)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(country.name.count) million people")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
