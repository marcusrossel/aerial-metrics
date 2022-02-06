//
//  ReelsView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 06.02.22.
//

import SwiftUI

struct ReelsView: View {
    
    @Binding var database: Database
    
    private var reels: [[MediaItem]] {
        database.groupedMediaItems.filter { $0.first?.mediaType == .reel }
    }
    
    @State private var showNewReelView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(reels.indexed(), id: \.1.first!.id) { (index, reel) in
                    NavigationLink {
                        Text("Reel \(reels.count - index)")
                    } label: {
                        Text("Reel \(reels.count - index) (\(reel.first!.date.formatted(date: .numeric, time: .omitted)))")
                            .fontWeight(.medium)
                    }
                }
            }
            
            Image(systemName: "film")
                .font(.system(size: 100))
                .foregroundColor(.secondary)
                .opacity(0.4)
        }
        .toolbar {
            Button {
                showNewReelView = true
            } label: {
                Label("Neuer Reel", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showNewReelView) {
            NewReelView(database: $database)
                .padding()
        }
    }
}
