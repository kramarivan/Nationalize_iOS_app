//
//  NationalizeViewModel.swift
//  Nationalize
//
//  Created by Ivan Kramar on 31.10.2024..
//


import SwiftUI
import Combine

class NationalizeViewModel: ObservableObject {
    @Published var result: NationalizeResult?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchNationality(for name: String) {
        guard let url = URL(string: "https://api.nationalize.io/?name=\(name)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        result = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        guard let data = data else {
                            self.errorMessage = "No data received"
                            return
                        }
                        do {
                            let decodedResult = try JSONDecoder().decode(NationalizeResult.self, from: data)
                            self.result = decodedResult
                        } catch {
                            self.errorMessage = "Failed to decode response"
                        }
                    case 401:
                        self.errorMessage = "Unauthorized: Invalid API key"
                    case 402:
                        self.errorMessage = "Payment Required: Subscription is not active"
                    case 422:
                        self.errorMessage = self.extractErrorMessage(from: data) ?? "Unprocessable Content"
                    case 429:
                        self.errorMessage = self.extractErrorMessage(from: data) ?? "Too many requests"
                    default:
                        self.errorMessage = "Unexpected error: \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
    
    private func extractErrorMessage(from data: Data?) -> String? {
        guard let data = data else { return nil }
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            return errorResponse.error
        } catch {
            return nil
        }
    }
}

