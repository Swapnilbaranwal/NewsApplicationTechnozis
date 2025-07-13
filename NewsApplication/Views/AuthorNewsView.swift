//
//  AuthorNewsView.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

struct AuthorNewsView: View {
    @StateObject var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if viewModel.authorArticles.isEmpty {
                    Text("No articles available. Please sync.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Text("Author: \(UserSession.shared.username)")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    List(viewModel.authorArticles.filter { CoreDataManager.shared.fetchDetail(for: $0.id) != nil }) { meta in
                        if let detail = CoreDataManager.shared.fetchDetail(for: meta.id) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(detail.article)
                                    .lineLimit(2)
                                    .font(.body)
                                Text("Approve Count: \(detail.approvedBy.count)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Author Panel")
        }
    }
}


