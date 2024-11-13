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
            ZStack{
            
            Color(red: 96 / 255, green: 139 / 255, blue: 193 / 255)
                                .ignoresSafeArea()
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
                Spacer()
                Image("roots").resizable().frame(width: 200, height:  200)
                Text("Where are your roots?").font(.largeTitle)
                Text("Find out where you share your name.").font(.callout)
                Spacer()
                TextField("Full Name or Last Name", text: $text)
                    .padding()
                    .background(Color(red: 96 / 255, green: 102 / 255, blue: 118 / 224))
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                
                
                Button("Nationalize") {
                    viewModel.fetchNationality(for: text)
                    $isNavigating.wrappedValue = true
                }
                .padding()
                .background(Color(red: 243 / 255, green: 243 / 255, blue: 193 / 224))
                .foregroundStyle(.black)
                .cornerRadius(5)
                Spacer()
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
        }.tint(Color.black)
    }
}


#Preview {
    NationalizeView()
}
