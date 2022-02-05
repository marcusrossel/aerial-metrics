//
//  TimelineDescriptor.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter
import SwiftUI

enum TimelineDescriptor: FieldDescriptor {
    
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

    var id: Self { self }
    
    var subfields: [Field<Self>] {
        switch self {
        case .gender(let gender): return AudienceInfo.AgeGroup.allCases.map { Field(.ageGroup(gender: gender, ageGroup: $0)) }
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
        case .date: return .vertical(alignment: .center).horizontal(alignment: .right)
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
        case .date:         return .header.width(9)
        case .followers:    return .header.width(8)
        case .follows:      return .header.width(6)
        case .mediaCount:   return .header.width(4)
        case .newFollowers: return .header.width(7)
        case .impressions:  return .header.width(11)
        case .profileViews: return .header.width(6)
        case .reach:        return .header.width(6)
        case .gender:       return .header
        case .ageGroup:     return .header.width(5)
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
