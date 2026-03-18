import Foundation

class APIClient {
    private let baseURL = "https://api.socialconnect.com/v1/"
    private let session = URLSession.shared
    
    func post(endpoint: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(false, NSError(domain: "APIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token from keychain
        if let token = KeychainManager.shared.getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, NSError(domain: "APIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }
            
            completion(200...299 ~= httpResponse.statusCode, nil)
        }
        
        task.resume()
    }
}
