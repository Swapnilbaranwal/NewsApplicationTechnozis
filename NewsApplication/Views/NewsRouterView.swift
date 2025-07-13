//
//  NewsRouterView.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

struct NewsRouterView: View {
    var body: some View {
        if UserSession.shared.isAuthor {
            AuthorNewsView()
        } else {
            ReviewerNewsView()
        }
    }
}

