//
//  Timeline.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 24.01.22.
//

import Foundation
import Algorithms

struct Timeline {
    
    let accountInfos: [AccountInfo]
    let audienceInfos: [AudienceInfo]
    let insights: Insights
    
    init(for database: Database) {
        accountInfos = database.accountInfos
        audienceInfos = database.audienceInfos
        insights = database.insights
    }
    
    var entries: [Entry] {
        dates.map { date in
            Entry(
                date: date,
                accountInfo: accountInfos.first { $0.lastUpdate == date },
                audienceInfo: audienceInfos.first { $0.lastUpdate == date },
                newFollowers: insights.followers[date],
                newImpressions: insights.impressions[date],
                newProfileViews: insights.profileViews[date],
                newReach: insights.reach[date]
            )
        }
        .chunked { lhs, rhs in Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date) }
        .map { chunk -> Entry in
            guard chunk.count > 1 else { return chunk.first! }
            return chunk.dropFirst().reduce(chunk.first!) { partialResult, next in
                merge(partialResult, next)
            }
        }
    }
    
    private var dates: [Date] {
        let raw: [Date] =
            accountInfos.map(\.lastUpdate) +
            audienceInfos.map(\.lastUpdate) +
            Array(insights.followers.keys) +
            Array(insights.impressions.keys) +
            Array(insights.profileViews.keys) +
            Array(insights.reach.keys)
        return Set(raw).sorted()
    }
    
    private func merge(_ lhs: Entry, _ rhs: Entry) -> Entry {
        guard Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date) else { fatalError() }
        
        let primary = lhs.date < rhs.date ? rhs : lhs
        let secondary = lhs.date < rhs.date ? lhs : rhs
        
        return Entry(
            date:            primary.date,
            accountInfo:     primary.accountInfo ?? secondary.accountInfo,
            audienceInfo:    primary.audienceInfo ?? secondary.audienceInfo,
            newFollowers:    primary.newFollowers ?? secondary.newFollowers,
            newImpressions:  primary.newImpressions ?? secondary.newImpressions,
            newProfileViews: primary.newProfileViews ?? secondary.newProfileViews,
            newReach:        primary.newReach ?? secondary.newReach
        )
    }
}

extension Timeline {
    
    struct Entry {
        
        let date: Date
        let accountInfo: AccountInfo?
        let audienceInfo: AudienceInfo?
        let newFollowers: Int?
        let newImpressions: Int?
        let newProfileViews: Int?
        let newReach: Int?
    }
}
