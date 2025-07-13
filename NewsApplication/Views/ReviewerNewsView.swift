//
//  ReviewerNewsView.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

struct ReviewerNewsView: View {
    @StateObject var viewModel = NewsViewModel()
    @State private var selectedIDs: Set<String> = []

    var body: some View {
        VStack {
            List {
                let authors = viewModel.groupedArticles.keys.sorted()

                ForEach(authors, id: \.self) { author in
                    if let articles = viewModel.groupedArticles[author] {
                        Section(header: Text(author)) {
                            ForEach(articles) { article in
                                HStack {
                                    Button(action: {
                                        toggleSelection(for: article.id)
                                    }) {
                                        Image(systemName: selectedIDs.contains(article.id) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(.blue)
                                    }

                                    Text("ID: \(article.id) • Approved: \(CoreDataManager.shared.fetchDetail(for: article.id)?.approvedBy.count ?? 0) times")
                                        .font(.body)
                                        .lineLimit(2)
                                }
//                                .onAppear {
//                                    // If this is the last article of the last section, load more
//                                    if author == authors.last && article.id == articles.last?.id {
//                                        viewModel.loadNextPage()
//                                    }
//                                }
                                .onAppear {
                                    if isLastVisible(articleID: article.id) {
                                        viewModel.loadNextPage()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button("Mark Approve") {
                viewModel.markApprove(selectedIDs: Array(selectedIDs))
                selectedIDs.removeAll()
            }
            .padding()
            .disabled(selectedIDs.isEmpty)
        }
        .navigationTitle("Reviewer Panel")
    }

    func toggleSelection(for id: String) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }
    func isLastVisible(articleID: String) -> Bool {
        let allArticles = viewModel.groupedArticles.values.flatMap { $0 }
        guard let last = allArticles.last else { return false }
        return articleID == last.id
    }

}
