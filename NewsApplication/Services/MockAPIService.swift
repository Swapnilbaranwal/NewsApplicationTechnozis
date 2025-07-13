//
//  MockAPIService.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//

import Foundation
import Network

struct MockAPIService {
    static func syncAllArticles(completion: @escaping () -> Void) {
        checkInternetAvailability { isConnected in
            guard isConnected else {
                print("❌ No internet connection")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .syncFailedNoInternet, object: nil)
                }
                return
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                guard let metadataURL = Bundle.main.url(forResource: "mockMetadata", withExtension: "json"),
                      let detailURL = Bundle.main.url(forResource: "mockDetail", withExtension: "json") else {
                    print("❌ Failed to locate JSON files in bundle.")
                    return
                }

                do {
                    let metadataData = try Data(contentsOf: metadataURL)
                    let serverMetadata = try JSONDecoder().decode([ArticleMetadata].self, from: metadataData)

                    let detailData = try Data(contentsOf: detailURL)
                    let serverDetails = try JSONDecoder().decode([ArticleDetail].self, from: detailData)

                    let localMetadata = CoreDataManager.shared.fetchMetadata()
                    let localDetails = localMetadata.compactMap {
                        CoreDataManager.shared.fetchDetail(for: $0.id)
                    }

                    var mergedMetadata: [ArticleMetadata] = []
                    var mergedDetails: [ArticleDetail] = []

                    for serverDetail in serverDetails {
                        if var local = CoreDataManager.shared.fetchDetail(for: serverDetail.id) {
                            var mergedSet = Set(local.approvedBy)
                            mergedSet.formUnion(serverDetail.approvedBy)
                            local.approvedBy = Array(mergedSet)
                            CoreDataManager.shared.saveDetail(local)
                            mergedDetails.append(local)
                        } else {
                            CoreDataManager.shared.saveDetail(serverDetail)
                            mergedDetails.append(serverDetail)
                        }
                    }

                    CoreDataManager.shared.saveMetadata(serverMetadata)
                    
                    // Simulate PUT by printing merged result
                    print("✅ Simulating PUT API call with \(mergedDetails.count) articles:")
                    mergedDetails.forEach { print("🔁 \( $0.id ) → \( $0.approvedBy )") }

                    // Save last sync time
                    UserDefaults.standard.set(Date(), forKey: "lastSync")

                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("❌ Sync failed with error: \(error)")
                }
            }
        }
    }

    private static func checkInternetAvailability(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetMonitor")
        monitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
            monitor.cancel()
        }
        monitor.start(queue: queue)
    }
}
