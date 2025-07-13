//
//  ArticleService.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

class ArticleService {
    func fetchMetadata(completion: @escaping ([ArticleMetadata]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(MockDataLoader.loadMetadata())
        }
    }

    func fetchDetail(for id: String, completion: @escaping (ArticleDetail) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(MockDataLoader.loadDetail(for: id))
        }
    }

    func syncAllData(
        localMetadata: [ArticleMetadata],
        localDetails: [UUID: ArticleDetail],
        completion: @escaping ([ArticleMetadata], [UUID: ArticleDetail]) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(localMetadata, localDetails) // simulate merge
        }
    }
}

