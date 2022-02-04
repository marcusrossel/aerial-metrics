//
//  TimelineField.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter
import SwiftUI

enum TimelineField: Field, Hashable, Codable {
    
    typealias Content = Timeline.Entry
    typealias Context = Void
    
    case date
    case followers
    case follows
    case mediaCount
    case newFollowers
    case impressions
    case profileViews
    case reach
    case gender(gender: AudienceInfo.Gender)
    case ageGroup(gender: AudienceInfo.Gender, ageGroup: AudienceInfo.AgeGroup)
    
    var id: TimelineField { self }
    
    var subfields: [TimelineField] {
        switch self {
        case .gender(let gender): return AudienceInfo.AgeGroup.allCases.map { .ageGroup(gender: gender, ageGroup: $0) }
        default: return []
        }
    }
    
    var title: String {
        switch self {
        case .date:                      return "Datum"
        case .followers:                 return "Follower"
        case .follows:                   return "Follows"
        case .mediaCount:                return "Posts"
        case .newFollowers:              return "Neue\nFollower"
        case .impressions:               return "Impressionen"
        case .profileViews:              return "Profil-\naufrufe"
        case .reach:                     return "Reich-\nweite"
        case .gender(let gender):        return gender.description
        case .ageGroup(_, let ageGroup): return ageGroup.description
        }
    }
    
    var style: Style? {
        switch self {
        case .date: return .verticalAlignment(.center).horizontalAlignment(.right)
        default: return .centered
        }
    }
    
    var titleMerge: Int? {
        switch self {
        case .gender, .ageGroup: return nil
        default: return 1
        }
    }
    
    var titleStyle: Style? {
        switch self {
        case .date, .followers, .follows, .mediaCount: return .header
        case .newFollowers, .impressions, .profileViews, .reach: return .header
        case .gender, .ageGroup: return .header
        }
    }
    
    var width: Double? {
        switch self {
        case .date:         return 9
        case .followers:    return 8
        case .follows:      return 6
        case .mediaCount:   return 4
        case .newFollowers: return 7
        case .impressions:  return 11
        case .profileViews: return 6
        case .reach:        return 6
        case .gender:       return nil
        case .ageGroup:     return 5
        }
    }
    
    func value(for content: Content, context: Context) -> Value? {
        switch self {
        case .date:         return .string(content.date.formatted(date: .numeric, time: .omitted))
        case .followers:    return (content.accountInfo?.followerCount).map(Value.int)
        case .follows:      return (content.accountInfo?.followCount).map(Value.int)
        case .mediaCount:   return (content.accountInfo?.mediaCount).map(Value.int)
        case .newFollowers: return content.newFollowers.map(Value.int)
        case .impressions:  return content.newImpressions.map(Value.int)
        case .profileViews: return content.newProfileViews.map(Value.int)
        case .reach:        return content.newReach.map(Value.int)
        case .gender:       return nil
        case let .ageGroup(gender, ageGroup):
            return content.audienceInfo?.demographics[gender]?[ageGroup].map(Value.int)
        }
    }
}
