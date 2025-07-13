//
//  NewsViewModel.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var groupedArticles: [String: [ArticleMetadata]] = [:]
    @Published var hasMorePages: Bool = true
    @Published var authorArticles: [ArticleMetadata] = []

    private var loadedIDs: Set<String> = []
    private var pageSize = 5
    private var currentPage = 0

    init() {
        loadNextPage()
        loadAuthorArticles()
    }

    func loadNextPage() {
        let all = CoreDataManager.shared.fetchMetadata()
        let start = currentPage * pageSize
        let end = min(start + pageSize, all.count)
        
        guard start < end else {
            hasMorePages = false
            return
        }
        
        let pageArticles = Array(all[start..<end])
        let grouped = Dictionary(grouping: pageArticles, by: { $0.author })
        
        // Replace instead of appending to avoid duplicates
        for (author, articles) in grouped {
            groupedArticles[author] = (groupedArticles[author] ?? []) + articles.filter { newArticle in
                !groupedArticles[author, default: []].contains(where: { $0.id == newArticle.id })
            }
        }
        
        currentPage += 1
        hasMorePages = end < all.count
    }


    func markApprove(selectedIDs: [String]) {
        let user = UserSession.shared.username
        for id in selectedIDs {
            CoreDataManager.shared.updateApproval(for: id, by: user)

            // Update the approveCount locally without reloading all
            for (author, articles) in groupedArticles {
                if let index = articles.firstIndex(where: { $0.id == id }) {
                    // Fetch updated approve count
                    let updatedCount = CoreDataManager.shared.fetchDetail(for: id)?.approvedBy.count ?? 0
                    groupedArticles[author]?[index].approveCount = updatedCount
                }
            }
        }
    }

    func loadAuthorArticles() {
        let all = CoreDataManager.shared.fetchMetadata()
        let currentUser = UserSession.shared.username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        // Use Set to remove duplicates by id
        var unique = [String: ArticleMetadata]()

        for meta in all {
            let authorName = meta.author.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if authorName == currentUser, unique[meta.id] == nil {
                if let detail = CoreDataManager.shared.fetchDetail(for: meta.id) {
                    unique[meta.id] = ArticleMetadata(id: meta.id, author: meta.author, approveCount: detail.approvedBy.count)
                    // 🟢 Print debug info for each article
                                    print("""
                                        🔹 Article ID: \(detail.id)
                                        🔹 Title: \(detail.name)
                                        🔹 Approve Count: \(detail.approvedBy.count)
                                        🔹 Approved By: \(detail.approvedBy)
                                        """)
                } else {
                    unique[meta.id] = meta
                }
            }
        }

        authorArticles = Array(unique.values)
        print("✅ Loaded author articles count: \(authorArticles.count)")
    }

}

