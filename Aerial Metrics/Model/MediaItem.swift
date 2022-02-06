//
//  MediaItem.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 23.01.22.
//

import Foundation

struct MediaItem: Identifiable {
    
    let likeCount: Int
    let commentCount: Int
    let productType: ProductType
    let mediaType: MediaType
    let url: URL
    let date: Date
    let hashtags: [String]
    let lastUpdate: Date
    let id: String
    
    var insights: MediaItem.Insights?
}

extension MediaItem {
    
    enum ProductType: String, Codable, CustomStringConvertible {
        
        case ad = "AD"
        case feed = "FEED"
        case igtv = "IGTV"
        case story = "STORY"
        
        var description: String {
            switch self {
            case .ad: return "Werbung"
            case .feed: return "Feed"
            case .igtv: return "IG-TV"
            case .story: return "Story"
            }
        }
    }

    enum MediaType: String, Codable, CustomStringConvertible {
        
        case carousel = "CAROUSEL_ALBUM"
        case image = "IMAGE"
        case video = "VIDEO"
        case reel = "REEL"
        
        var description: String {
            switch self {
            case .carousel: return "Carousel"
            case .image: return "Bild"
            case .video: return "Video"
            case .reel: return "Reel"
            }
        }
    }
}

extension MediaItem {
    
    struct List: Codable {
        var data: [MediaItem]
    }
}

extension MediaItem: Codable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case likeCount = "like_count"
        case commentCount = "comments_count"
        case productType = "media_product_type"
        case mediaType = "media_type"
        case caption = "caption"
        case url = "permalink"
        case date = "timestamp"
        case id = "id"
        case lastUpdate = "lastUpdate"
        case insights = "insights"
        
        static var requestFields: [CodingKeys] { Self.allCases.dropLast(2) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        likeCount = try container.decode(Int.self, forKey: .likeCount)
        commentCount = try container.decode(Int.self, forKey: .commentCount)
        productType = try container.decode(ProductType.self, forKey: .productType)
        mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        url = try container.decode(URL.self, forKey: .url)
        date = try container.decode(Date.self, forKey: .date)
        lastUpdate = try container.decodeIfPresent(Date.self, forKey: .lastUpdate) ?? Date()
        id = try container.decode(String.self, forKey: .id)
        insights = try container.decodeIfPresent(MediaItem.Insights.self, forKey: .insights)
        
        hashtags = try container.decode(String.self, forKey: .caption)
            .split(whereSeparator: \.isWhitespace)
            .filter { $0.hasPrefix("#") }
            .map(String.init)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(commentCount, forKey: .commentCount)
        try container.encode(productType, forKey: .productType)
        try container.encode(mediaType, forKey: .mediaType)
        try container.encode(url, forKey: .url)
        try container.encode(date, forKey: .date)
        try container.encode(hashtags.joined(separator: " "), forKey: .caption)
        try container.encode(lastUpdate, forKey: .lastUpdate)
        try container.encode(id, forKey: .id)
        try container.encode(insights, forKey: .insights)
    }
}
