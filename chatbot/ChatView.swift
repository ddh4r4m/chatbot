//
//  ChatView.swift
//  chatbot
//
//  Created by Dharam Dhurandhar on 14/01/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var webSocketManager = WebSocketManager()
    @State private var inputText: String = ""

    var body: some View {
        VStack {
            // Messages list
            List(webSocketManager.messages) { message in
                HStack {
                    if message.isSentByUser {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            .listStyle(PlainListStyle())

            // Text input field
            HStack {
                TextField("Type a message", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding()
            }
        }
        .navigationBarTitle("Chatbot", displayMode: .inline)
        .onAppear {
            webSocketManager.connect()
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
    }

    private func sendMessage() {
        let userMessage = Message(text: inputText, isSentByUser: true)
        webSocketManager.messages.append(userMessage)
        webSocketManager.sendMessage(inputText)
        inputText = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

#Preview {
    ChatView()
}
