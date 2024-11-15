//
//  NationalizeViewModel.swift
//  Nationalize
//
//  Created by Ivan Kramar on 31.10.2024..
//


import SwiftUI
import Combine

/// ViewModel to handle fetching and decoding data from the Nationalize API.
/// This class is responsible for managing state and error handling.
class NationalizeViewModel: ObservableObject {
    /// Published property to store the fetched result from the Nationalize API.
    @Published var result: NationalizeResult?
    /// Published property to indicate whether a request is in progress.
    @Published var isLoading: Bool = false
    /// Published property to store an error message, if any.
    @Published var errorMessage: String?

    /// Fetches the nationality predictions for a given name using the Nationalize API.
    /// - Parameter name: The name for which to fetch nationality predictions.
    func fetchNationality(for name: String) {
        // Construct the API URL with the given name.
        guard let url = URL(string: "https://api.nationalize.io/?name=\(name)") else {
            // Set an error message if the URL is invalid.
            errorMessage = "Invalid URL"
            return
        }
        
        // Update the state to indicate loading and clear previous data/errors.
        isLoading = true
        errorMessage = nil
        result = nil
        
        // Perform a network request using URLSession.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Ensure UI updates happen on the main thread.
            DispatchQueue.main.async {
                // Request completed; stop the loading indicator.
                self.isLoading = false
                
                // Handle network errors.
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                // Check the HTTP response for status code and handle accordingly.
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        // Successful response. Attempt to decode the data.
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
                        // Unauthorized: API key is invalid or missing.
                        self.errorMessage = "Unauthorized: Invalid API key"
                    case 402:
                        // Payment required: Subscription is not active.
                        self.errorMessage = "Payment Required: Subscription is not active"
                    case 422:
                        // Unprocessable content: Attempt to extract a more specific error message.
                        self.errorMessage = self.extractErrorMessage(from: data) ?? "Unprocessable Content"
                    case 429:
                        // Too many requests: API rate limit exceeded.
                        self.errorMessage = self.extractErrorMessage(from: data) ?? "Too many requests"
                    default:
                        // Handle unexpected status codes.
                        self.errorMessage = "Unexpected error: \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume() // Start the network task.
    }
    
    /// Extracts an error message from the provided data, if possible.
    /// - Parameter data: The raw data returned from the API.
    /// - Returns: A string containing the error message, or `nil` if extraction fails.
    private func extractErrorMessage(from data: Data?) -> String? {
        // Ensure data is not nil before attempting to decode.
        guard let data = data else { return nil }
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            return errorResponse.error
        } catch {
            // Return nil if decoding fails.
            return nil
        }
    }
}

