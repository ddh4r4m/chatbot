//
//  WebSocketManager.swift
//  chatbot
//
//  Created by Dharam Dhurandhar on 14/01/24.
//

import Foundation

class WebSocketManager: ObservableObject {
    @Published var messages: [Message] = []

    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
//        let url = URL(string: "ws://127.0.0.1:5000")! // Replace with your server's URL
//        let url = URL(string: "ws://connect.websocket.in/v3/1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self")! // Replace with your server's URL
        let url = URL(string: "wss://connect.websocket.in/v3/1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self")! // Replace with your server's URL
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()

        receiveMessage()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }

    func sendMessage(_ text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(.string(let text)):
                DispatchQueue.main.async {
                    self?.messages.append(Message(text: text, isSentByUser: false))
                }
                self?.receiveMessage()
            default:
                break
            }
        }
    }
}
