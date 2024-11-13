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
        ZStack{
        Color(red: 96 / 255, green: 139 / 255, blue: 193 / 255)
                            .ignoresSafeArea()
        VStack(alignment: .leading, spacing: 15) {
            Text("Name: \(result.name)")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("Count: \(result.count)")
                .font(.subheadline)
                .padding(.bottom, 10)
            
            Text("Countries")
                .font(.title2)
                .padding(.bottom, 5)
            
            // Table for countries and probabilities
            VStack(spacing: 8) {
                HStack {
                    Text("Country ID")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Probability")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 2)
                
                Divider()
                ScrollView(content: {
                    ForEach(result.country, id: \.country_id) { country in
                        HStack {
                            Text(country.country_id)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "%.1f%%", country.probability * 100))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 2)
                    }
                })
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Results")
    }
    }
}

#Preview {
    ResultView(result: NationalizeResult.init(count: 10, name: "Kramar", country: [Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2), Country(country_id: "HR", probability: 0.33), Country(country_id: "SI", probability: 0.2)]))
}
