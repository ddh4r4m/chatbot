//
//  NetworkManager.swift
//  chatbot
//
//  Created by Dharam Dhurandhar on 14/01/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let serverURL = URL(string: "http://127.0.0.1:5000/chat")!

    func sendMessage(_ message: String, completion: @escaping (String) -> Void) {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["message": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([String: String].self, from: data) {
                DispatchQueue.main.async {
                    completion(decodedResponse["response"] ?? "No response")
                }
            }
        }.resume()
    }
}
