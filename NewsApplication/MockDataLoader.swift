//
//  MockDataLoader.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

struct MockDataLoader {
    static func loadMetadata() -> [ArticleMetadata] {
        return (1...15).map {
            ArticleMetadata(
                id: "ART\(String(format: "%03d", $0))",
                author: $0 % 2 == 0 ? "Robert" : "Alice",
                approveCount: Int.random(in: 0...10)
            )
        }
    }

    static func loadDetail(for id: String) -> ArticleDetail {
        return ArticleDetail(
            id: id,
            name: "Title for \(id)",
            article: "Detailed article content for \(id).",
            createdAt: "2023-12-01T10:00:00Z",
            updatedAt: "2025-07-01T10:00:00Z",
            approvedBy: []
        )
    }
}
