//
//  PostsField.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter
import Foundation

enum PostsField: Field, Codable {
    
    typealias Content = MediaItem
    
    struct Context {
        var isFirst: Bool
        let postNumber: Int
        let isVideo: Bool
        let blockSize: Int
    }
    
    case url
    case date
    case likes
    case comments
    case saves
    case engagement
    case impressions
    case reach
    case videoViews
    case mediaType
    case postDate
    case productType
    case storyReplies
    case storyExits
    case storyTapsForward
    case storyTapsBackward
    case hashtags

    var id: Self { self }
    
    var title: String {
        switch self {
        case .url: return "URL"
        case .date: return "Datum"
        case .likes: return "Likes"
        case .comments: return "Kommentare"
        case .saves: return "Saves"
        case .engagement: return "Engagement"
        case .impressions: return "Impressionen"
        case .reach: return "Reich-\nweite"
        case .videoViews: return "Video-\naufrufe"
        case .mediaType: return "Medien-\ntyp"
        case .postDate: return "Geposted"
        case .productType: return "Produkt-\ntyp"
        case .storyReplies: return "Story\nAntworten"
        case .storyExits: return "Story\nExits"
        case .storyTapsForward: return "Story\nTaps ➡️"
        case .storyTapsBackward: return "Story\nTaps ⬅️"
        case .hashtags: return "Hashtags"
        }
    }
    
    var titleMerge: Int? { 1 }
    
    var titleStyle: Style? {
        switch self {
        case .url, .date: return .headerBlue
        case .likes, .comments, .saves, .engagement, .impressions, .reach, .videoViews: return .headerGreen
        case .mediaType, .postDate, .productType, .storyReplies, .storyExits, .storyTapsForward, .storyTapsBackward, .hashtags: return .headerOrange
        }
    }
    
    var style: Style? {
        switch self {
        case .url: return .url
        case .date: return .rightAligned
        case .hashtags: return .long
        default: return .data
        }
    }
    
    var width: Double? {
        switch self {
        case .url: return nil
        case .date: return nil
        case .likes: return 5
        case .comments: return 10
        case .saves: return 6
        case .engagement: return 11
        case .impressions: return 11
        case .reach: return 6
        case .videoViews: return nil
        case .mediaType: return 8
        case .postDate: return nil
        case .productType: return 8
        case .storyReplies: return nil
        case .storyExits: return 6
        case .storyTapsForward: return nil
        case .storyTapsBackward: return nil
        case .hashtags: return 100
        }
    }
    
    func merge(for content: Content, context: Context) -> Int? {
        guard context.isFirst, context.blockSize > 1 else { return nil }
        
        switch self {
        case .url, .mediaType, .postDate, .productType, .hashtags: return context.blockSize - 1
        case .videoViews: if !context.isVideo { return context.blockSize - 1 } else { return nil }
        default: return nil
        }
    }
    
    func value(for content: Content, context: Context) -> Value? {
        switch (self, context.isFirst) {
        case (.url, true):            return .url(content.url, title: "Post \(context.postNumber)")
        case (.date, _):              return .string(content.lastUpdate.formatted(date: .numeric, time: .omitted))
        case (.likes, _):             return .int(content.likeCount)
        case (.comments, _):          return .int(content.commentCount)
        case (.saves, _):             return (content.insights?.saved).map(Value.int)
        case (.engagement, _):        return (content.insights?.engagement).map(Value.int)
        case (.impressions, _):       return (content.insights?.impressions).map(Value.int)
        case (.reach, _):             return (content.insights?.reach).map(Value.int)
        case (.videoViews, _):        return context.isVideo ? (content.insights?.videoViews).map(Value.int) : nil
        case (.mediaType, true):      return .stringable(content.mediaType)
        case (.postDate, true):       return .string(content.date.formatted(date: .numeric, time: .omitted))
        case (.productType, true):    return .stringable(content.productType)
        case (.storyReplies, _):      return (content.insights?.replies).map(Value.int)
        case (.storyExits, _):        return (content.insights?.exits).map(Value.int)
        case (.storyTapsForward, _):  return (content.insights?.tapsForward).map(Value.int)
        case (.storyTapsBackward, _): return (content.insights?.tapsBack).map(Value.int)
        case (.hashtags, true):
            guard !content.hashTags.isEmpty else { return nil }
            
            let lines = Double(context.blockSize) * 1.33
            let tagsPerLine = Double(content.hashTags.count) / lines
            let hashTags = content.hashTags
                .map(\.localizedLowercase)
                .sorted()
                .chunks(ofCount: Int(tagsPerLine.rounded(.up)))
                .map { $0.joined(separator: " ") }
                .joined(separator: "\n")
            
            return .string(hashTags)
        default: return nil
        }
    }
}
