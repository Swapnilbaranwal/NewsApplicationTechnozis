//
//  ArticleMetadata.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

struct ArticleMetadata: Identifiable, Codable, Equatable {
    let id: String
    let author: String
    var approveCount: Int

    enum CodingKeys: String, CodingKey {
        case id = "articleId"
        case author
        case approveCount
    }
}

struct ArticleDetail: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let article: String
    let createdAt: String
    let updatedAt: String
    var approvedBy: [String]

    enum CodingKeys: String, CodingKey {
        case id = "articleId"
        case name
        case article
        case createdAt
        case updatedAt
        case approvedBy
    }
}


extension ArticleMetadata {
    var summaryText: String {
        "ID: \(id) • Approved: \(approveCount) times"
    }
}
