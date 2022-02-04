//
//  AccountInfo.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 23.01.22.
//

import Foundation

struct AccountInfo {
    let followerCount: Int
    let followCount: Int
    let mediaCount: Int
    let lastUpdate: Date
}

extension AccountInfo: Codable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        
        case followerCount = "followers_count"
        case followCount = "follows_count"
        case mediaCount = "media_count"
        case lastUpdate = "lastUpdate"
        
        static var requestFields: [CodingKeys] { Self.allCases.dropLast() }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lastUpdate = try container.decodeIfPresent(Date.self, forKey: .lastUpdate) ?? Date()
        followerCount = try container.decode(Int.self, forKey: .followerCount)
        followCount = try container.decode(Int.self, forKey: .followCount)
        mediaCount = try container.decode(Int.self, forKey: .mediaCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(lastUpdate, forKey: .lastUpdate)
        try container.encode(followerCount, forKey: .followerCount)
        try container.encode(followCount, forKey: .followCount)
        try container.encode(mediaCount, forKey: .mediaCount)
    }
}
