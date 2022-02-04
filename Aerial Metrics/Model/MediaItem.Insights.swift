//
//  MediaItem.Insights.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 24.01.22.
//

import Foundation

extension MediaItem {
    
    struct Insights {
        
        let impressions: Int
        let reach: Int
        
        // Photos/Videos/Carousels:
        let engagement: Int?
        let saved: Int?
        
        // Videos/Carousels:
        let videoViews: Int?
        
        // Stories:
        let exits: Int?
        let replies: Int?
        let tapsForward: Int?
        let tapsBack: Int?
    }
}

extension MediaItem.Insights: Codable {
    
    private struct APIContainer: Codable {
        
        enum CodingKeys: String, CodingKey { case data }
        
        let data: [Entry]
        
        struct Entry: Codable {
            let name: String
            let values: [Value]
            
            struct Value: Codable {
                let value: Int
            }
        }
    }
    
    enum DecodingError: Error {
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: APIContainer.CodingKeys.self)
        let entries = try container.decode([APIContainer.Entry].self, forKey: .data)
        
        guard
            entries.count >= 2,
            entries.allSatisfy({ $0.values.count == 1 }),
            let impressions = entries.first(where: { $0.name == InstagramAPI.Metric.impressions.rawValue })?.values.first?.value,
            let reach = entries.first(where: { $0.name == InstagramAPI.Metric.reach.rawValue })?.values.first?.value
        else { throw DecodingError.error }
        
        self.impressions = impressions
        self.reach = reach
        self.engagement = entries.first(where: { $0.name == InstagramAPI.Metric.engagement.rawValue })?.values.first?.value
        self.saved = entries.first(where: { $0.name == InstagramAPI.Metric.saved.rawValue })?.values.first?.value
        self.videoViews = entries.first(where: { $0.name == InstagramAPI.Metric.videoViews.rawValue })?.values.first?.value
        self.exits = entries.first(where: { $0.name == InstagramAPI.Metric.exits.rawValue })?.values.first?.value
        self.replies = entries.first(where: { $0.name == InstagramAPI.Metric.replies.rawValue })?.values.first?.value
        self.tapsForward = entries.first(where: { $0.name == InstagramAPI.Metric.tapsForward.rawValue })?.values.first?.value
        self.tapsBack = entries.first(where: { $0.name == InstagramAPI.Metric.tapsBack.rawValue })?.values.first?.value
    }
    
    func encode(to encoder: Encoder) throws {
        var data: [APIContainer.Entry] = [
            APIContainer.Entry(
                name: InstagramAPI.Metric.impressions.rawValue,
                values: [APIContainer.Entry.Value(value: impressions)]
            ),
            APIContainer.Entry(
                name: InstagramAPI.Metric.reach.rawValue,
                values: [APIContainer.Entry.Value(value: reach)]
            )
        ]
        
        if let engagement = engagement {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.engagement.rawValue,
                values: [APIContainer.Entry.Value(value: engagement)]
            )]
        }
            
        if let saved = saved {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.saved.rawValue,
                values: [APIContainer.Entry.Value(value: saved)]
            )]
        }
            
        if let videoViews = videoViews {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.videoViews.rawValue,
                values: [APIContainer.Entry.Value(value: videoViews)]
            )]
        }
            
        if let exits = exits {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.exits.rawValue,
                values: [APIContainer.Entry.Value(value: exits)]
            )]
        }
            
        if let replies = replies {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.replies.rawValue,
                values: [APIContainer.Entry.Value(value: replies)]
            )]
        }
            
        if let tapsForward = tapsForward {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.tapsForward.rawValue,
                values: [APIContainer.Entry.Value(value: tapsForward)]
            )]
        }
            
        if let tapsBack = tapsBack {
            data += [APIContainer.Entry(
                name: InstagramAPI.Metric.tapsBack.rawValue,
                values: [APIContainer.Entry.Value(value: tapsBack)]
            )]
        }
        
        var container = encoder.container(keyedBy: APIContainer.CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
}

