//
//  CoreDataManager.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "CoredataNewsApplication")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Error saving context: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Save Metadata (Avoid Duplicates)
    func saveMetadata(_ metadataList: [ArticleMetadata]) {
        for metadata in metadataList {
            let request: NSFetchRequest<ArticleMetadataEntity> = ArticleMetadataEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", metadata.id)

            if let result = try? context.fetch(request), let entity = result.first {
                // Update only if needed
                entity.author = metadata.author.trimmingCharacters(in: .whitespacesAndNewlines)
                entity.approveCount = Int16(metadata.approveCount)
            } else {
                let entity = ArticleMetadataEntity(context: context)
                entity.id = metadata.id
                entity.author = metadata.author.trimmingCharacters(in: .whitespacesAndNewlines)
                entity.approveCount = Int16(metadata.approveCount)
            }
        }
        saveContext()
    }


    // MARK: - Save Detail
    func saveDetail(_ detail: ArticleDetail) {
        let request: NSFetchRequest<ArticleDetailEntity> = ArticleDetailEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", detail.id)

        // Filter out any invalid or empty strings just in case
        let cleanApprovedBy = detail.approvedBy.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        if let result = try? context.fetch(request), let existing = result.first {
            existing.name = detail.name
            existing.article = detail.article
            existing.createdAt = detail.createdAt
            existing.updatedAt = detail.updatedAt
            existing.approvedBy = cleanApprovedBy as NSArray
        } else {
            let entity = ArticleDetailEntity(context: context)
            entity.id = detail.id
            entity.name = detail.name
            entity.article = detail.article
            entity.createdAt = detail.createdAt
            entity.updatedAt = detail.updatedAt
            entity.approvedBy = cleanApprovedBy as NSArray
        }

        saveContext()
    }

    // MARK: - Fetch Metadata
    func fetchMetadata() -> [ArticleMetadata] {
        let request: NSFetchRequest<ArticleMetadataEntity> = ArticleMetadataEntity.fetchRequest()
        guard let result = try? context.fetch(request) else { return [] }
        
        return result.compactMap { entity in
            guard let id = entity.id, let author = entity.author else { return nil }
            // 🔁 Dynamically fetch count from detail for latest data
            let approvedByCount = (fetchDetail(for: id)?.approvedBy.count) ?? 0
            return ArticleMetadata(id: id, author: author, approveCount: approvedByCount)
        }
    }
    // MARK: - Fetch Detail
    func fetchDetail(for id: String) -> ArticleDetail? {
        let request: NSFetchRequest<ArticleDetailEntity> = ArticleDetailEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        guard let result = try? context.fetch(request), let entity = result.first else {
            return nil
        }

        return ArticleDetail(
            id: entity.id ?? "",
            name: entity.name ?? "",
            article: entity.article ?? "",
            createdAt: entity.createdAt ?? "",
            updatedAt: entity.updatedAt ?? "",
            approvedBy: (entity.approvedBy as? [String]) ?? []
        )
    }

    // MARK: - Update Approvals
    func updateApproval(for id: String, by user: String) {
        let detailRequest: NSFetchRequest<ArticleDetailEntity> = ArticleDetailEntity.fetchRequest()
        detailRequest.predicate = NSPredicate(format: "id == %@", id)

        let metadataRequest: NSFetchRequest<ArticleMetadataEntity> = ArticleMetadataEntity.fetchRequest()
        metadataRequest.predicate = NSPredicate(format: "id == %@", id)

        if let detailResult = try? context.fetch(detailRequest),
           let detail = detailResult.first {

            var approved = (detail.approvedBy as? [String]) ?? []
            if !approved.contains(user) {
                approved.append(user)
                detail.approvedBy = approved as NSArray

                // 🔁 Also update approveCount in metadata
                if let metadata = try? context.fetch(metadataRequest).first {
                    metadata.approveCount = Int16(approved.count)
                }

                saveContext()
            }
        }
    }
    
    func clearAllApprovals() {
        let request: NSFetchRequest<ArticleDetailEntity> = ArticleDetailEntity.fetchRequest()

        do {
            let results = try context.fetch(request)
            for entity in results {
                entity.approvedBy = [] as NSArray
            }
            saveContext()
            print("✅ Cleared all approvedBy entries.")
        } catch {
            print("❌ Failed to clear approvals: \(error)")
        }
    }


}
