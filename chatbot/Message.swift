//
//  Message.swift
//  chatbot
//
//  Created by Dharam Dhurandhar on 14/01/24.
//

import Foundation

struct Message: Identifiable {
    let id: UUID = UUID()
    let text: String
    let isSentByUser: Bool
}
