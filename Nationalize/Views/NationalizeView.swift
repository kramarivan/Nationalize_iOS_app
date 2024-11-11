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
    @State private var isNavigating: Bool = false
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }else{
            VStack(spacing: 20) {
                Spacer()
                Image("roots").resizable().frame(width: 200, height:  200)
                Text("How Many of You?").font(.largeTitle)
                Text("Find out where you share your name.").font(.callout)
                Spacer()
                TextField("Full Name or Last Name", text: $text)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(5)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                
                
                Button("Nationalize") {
                    viewModel.fetchNationality(for: text)
                    $isNavigating.wrappedValue = true
                }
                .padding()
                .background(Color.brown)
                .foregroundStyle(.white)
                .cornerRadius(5)
                Spacer()
                
            }
            .padding()
            .navigationDestination(isPresented: $isNavigating) {
                if let result = viewModel.result {
                    ResultView(result: result)
                }
            }
            }
        }
    }
}


#Preview {
    NationalizeView()
}
