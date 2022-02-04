//
//  Insights.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 23.01.22.
//

import Foundation

struct Insights {
    
    var followers: [Date: Int] = [:]
    var impressions: [Date: Int] = [:]
    var profileViews: [Date: Int] = [:]
    var reach: [Date: Int] = [:]
    
    mutating func merge(_ insights: Insights) {
        followers.merge(insights.followers) { old, new in new }
        impressions.merge(insights.impressions) { old, new in new }
        profileViews.merge(insights.profileViews) { old, new in new }
        reach.merge(insights.reach) { old, new in new }
    }
}

extension Insights: Codable {
    
    private struct APIContainer: Codable {
        
        enum CodingKeys: String, CodingKey { case data }
        
        let data: [Entry]
        
        struct Entry: Codable {
            let name: String
            let values: [Value]
            
            struct Value: Codable {
                let end_time: Date
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
            entries.count == 4,
            let followers = entries.first(where: { $0.name == InstagramAPI.Metric.followerCount.rawValue }),
            let impressions = entries.first(where: { $0.name == InstagramAPI.Metric.impressions.rawValue }),
            let profileViews = entries.first(where: { $0.name == InstagramAPI.Metric.profileViews.rawValue }),
            let reach = entries.first(where: { $0.name == InstagramAPI.Metric.reach.rawValue })
        else { throw DecodingError.error }
        
        self.followers = Dictionary(uniqueKeysWithValues: followers.values.map { ($0.end_time, $0.value) })
        self.impressions = Dictionary(uniqueKeysWithValues: impressions.values.map { ($0.end_time, $0.value) })
        self.profileViews = Dictionary(uniqueKeysWithValues: profileViews.values.map { ($0.end_time, $0.value) })
        self.reach = Dictionary(uniqueKeysWithValues: reach.values.map { ($0.end_time, $0.value) })
    }
    
    func encode(to encoder: Encoder) throws {
        let data = [
            APIContainer.Entry(
                name: InstagramAPI.Metric.followerCount.rawValue,
                values: followers.sorted { _, _ in true }.map(APIContainer.Entry.Value.init(end_time:value:))
            ),
            APIContainer.Entry(
                name: InstagramAPI.Metric.impressions.rawValue,
                values: impressions.sorted { _, _ in true }.map(APIContainer.Entry.Value.init(end_time:value:))
            ),
            APIContainer.Entry(
                name: InstagramAPI.Metric.profileViews.rawValue,
                values: profileViews.sorted { _, _ in true }.map(APIContainer.Entry.Value.init(end_time:value:))
            ),
            APIContainer.Entry(
                name: InstagramAPI.Metric.reach.rawValue,
                values: reach.sorted { _, _ in true }.map(APIContainer.Entry.Value.init(end_time:value:))
            )
        ]
        
        var container = encoder.container(keyedBy: APIContainer.CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
}
