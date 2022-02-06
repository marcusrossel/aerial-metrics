//
//  NewReelView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 06.02.22.
//

import SwiftUI

struct NewReelView: View {
    
    @Binding var database: Database
    
    @Environment(\.dismiss) private var dismiss
    
    private var reels: [[MediaItem]] {
        database.groupedMediaItems.filter { $0.first?.mediaType == .reel }
    }
    
    @State private var url = ""
    @State private var likes = ""
    @State private var views = ""
    @State private var comments = ""
    @State private var hashtags = ""
    @State private var postDate = Date()
    
    var body: some View {
        VStack(spacing: 24) {
            Label("Reel \(reels.count + 1)", systemImage: "film")
                .font(.headline)
            
            VStack {
                TextField("URL", text: $url)
                TextField("Likes", text: $likes)
                TextField("Views", text: $views)
                TextField("Kommentare", text: $comments)
                TextField("Hashtags", text: $hashtags)
                DatePicker("Post Datum", selection: $postDate)
            }
                
            HStack {
                Button("Speichern", action: save)
                Button("Abbrechen", action: { dismiss() })
            }
        }
    }
    
    private func save() {
        guard let url = URL(string: url), let likes = Int(likes), let views = Int(views), let comments = Int(comments) else { return }
        
        let hashtags = hashtags
            .split(whereSeparator: \.isWhitespace)
            .filter { $0.hasPrefix("#") }
            .map(String.init)
        
        let mediaItem = MediaItem(likeCount: likes, commentCount: comments, productType: .feed, mediaType: .reel, url: url, date: postDate, hashtags: hashtags, lastUpdate: Date(), id: UUID().uuidString, insights: MediaItem.Insights(videoViews: views))
        
        database.mediaItems.append(mediaItem)
        
        switch DatabaseManager.write(database: database) {
        case .none: dismiss()
        default: break // Handle errors.
        }
    }
}
