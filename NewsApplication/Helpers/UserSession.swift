//
//  UserSession.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var username: String = ""
    @Published var role: UserRole = .reviewer

    func login(_ name: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.username = cleanName
        self.role = cleanName.lowercased() == "robert" ? .author : .reviewer
        UserDefaults.standard.set(cleanName, forKey: "username")
        UserDefaults.standard.set(role.rawValue, forKey: "role")
    }

    func load() {
        let name = UserDefaults.standard.string(forKey: "username") ?? ""
        username = name
        role = UserRole(rawValue: UserDefaults.standard.string(forKey: "role") ?? "reviewer") ?? .reviewer
    }

    var isAuthor: Bool {
        role == .author
    }

    var isReviewer: Bool {
        role == .reviewer
    }
}

enum UserRole: String {
    case author
    case reviewer
}
