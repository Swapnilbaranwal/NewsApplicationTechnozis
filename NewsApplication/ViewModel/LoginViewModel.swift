//
//  LoginViewModel.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var shouldNavigate = false
    @Published var showAlert = false
    @Published var isSyncing = false

    init() {
        NotificationCenter.default.addObserver(forName: .syncFailedNoInternet, object: nil, queue: .main) { _ in
            self.showAlert = true
        }
    }
    
    func login() {
        let articles = CoreDataManager.shared.fetchMetadata()
        print("✅ All articles after sync: \(articles.map { "\($0.author): \($0.id)" })")
        guard !articles.isEmpty else {
            showAlert = true
            return
        }
        UserSession.shared.login(username.trimmingCharacters(in: .whitespacesAndNewlines))
        shouldNavigate = true
    }

    func sync(completion: @escaping () -> Void) {
        isSyncing = true
        MockAPIService.syncAllArticles {
            DispatchQueue.main.async {
                self.isSyncing = false
                completion()
            }
        }
    }
}

extension Notification.Name {
    static let syncFailedNoInternet = Notification.Name("syncFailedNoInternet")
}
