//
//  ResultView.swift
//  Nationalize
//
//  Created by Ivan Kramar on 01.11.2024..
//


import SwiftUI

struct ResultView: View {
    let result: NationalizeResult

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Name: \(result.name)")
            Text("Count: \(result.count)")
            Text("Countries:")
            ForEach(result.country, id: \.country_id) { country in
                Text("\(country.country_id): \(String(format: "%.1f%%", country.probability * 100))")
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Results")
    }
}