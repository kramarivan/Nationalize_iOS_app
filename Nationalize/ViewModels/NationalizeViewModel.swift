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
            }
        }.resume()
    }
}
