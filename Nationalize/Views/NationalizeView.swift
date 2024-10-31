//
//  ContentView.swift
//  Nationalize
//
//  Created by Ivan Kramar on 31.10.2024..
//

import SwiftUI

struct NationalizeView: View {
    @State private var text: String = ""
    @ObservedObject private var viewModel = NationalizeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter the last name or full name of a person")
            
            TextField("Name", text: $text)
                .padding()
                .background(Color.teal)
                .cornerRadius(3)
                .foregroundColor(.white)
            
            Button("Nationalize") {
                viewModel.fetchNationality(for: text)
            }
            .padding()

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)  // Adjusts size for better visibility
            } else if let result = viewModel.result {
                VStack(alignment: .leading) {
                    Text("Name: \(result.name)")
                    Text("Count: \(result.count)")
                    Text("Countries:")
                    ForEach(result.country, id: \.country_id) { country in
                        Text("\(country.country_id): \(String(format: "%.1f%%", country.probability * 100))")
                    }
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}


#Preview {
    NationalizeView()
}
