//
//  Database.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 27.01.22.
//

import Foundation

struct Database: Codable {
    
    var accountInfos: [AccountInfo] = []
    var audienceInfos: [AudienceInfo] = []
    var mediaItems: [MediaItem] = []
    var insights = Insights()
    var excelLayouts = ExcelLayouts()
    
    mutating func merge(_ accountInfo: AccountInfo) {
        let redundant = accountInfos.firstIndex{ Calendar.current.isDate(accountInfo.lastUpdate, inSameDayAs: $0.lastUpdate) }
        if let index = redundant {
            accountInfos[index] = accountInfo
        } else {
            accountInfos.append(accountInfo)
        }
    }
    
    mutating func merge(_ audienceInfo: AudienceInfo) {
        let redundant = audienceInfos.firstIndex{ Calendar.current.isDate(audienceInfo.lastUpdate, inSameDayAs: $0.lastUpdate) }
        if let index = redundant {
            audienceInfos[index] = audienceInfo
        } else {
            audienceInfos.append(audienceInfo)
        }
    }
    
    mutating func merge(_ mediaItems: [MediaItem]) {
        for item in mediaItems {
            let redundant = self.mediaItems.firstIndex{
                item.id == $0.id &&
                Calendar.current.isDate(item.lastUpdate, inSameDayAs: $0.lastUpdate)
            }
            
            if let index = redundant {
                self.mediaItems[index] = item
            } else {
                self.mediaItems.append(item)
            }
        }
    }
    
    mutating func merge(_ insights: Insights) {
        self.insights.merge(insights)
    }
}

extension Database {
    
    struct ExcelLayouts: Codable {
        var timeline = TimelineLayout()
        var posts = PostsLayout()
        var cities = CitiesLayout()
    }
}
