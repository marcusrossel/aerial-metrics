//
//  InstagramAPI.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 22.01.22.
//

import Foundation

struct InstagramAPI {
    
    private let host = "https://graph.facebook.com/v12.0/"
    let accountID: String
    var accessToken: String
    
    init(accountID: String, accessToken: String) {
        self.accountID = accountID
        self.accessToken = accessToken
    }
}

extension InstagramAPI {
    
    fileprivate enum Endpoint: String {
        case media = "/media"
        case insights = "/insights"
    }
}

extension InstagramAPI {
    
    enum Metric: String {
         
        case audienceCity = "audience_city"
        case audienceGenderAge = "audience_gender_age"
        case followerCount = "follower_count"
        case profileViews = "profile_views"
        case impressions = "impressions"
        case reach = "reach"
        case engagement = "engagement"
        case saved = "saved"
        case videoViews = "video_views"
        case exits = "exits"
        case replies = "replies"
        case tapsForward = "taps_forward"
        case tapsBack = "taps_back"
        
        fileprivate var period: String {
            switch self {
            case .audienceCity, .audienceGenderAge: return "lifetime"
            case .followerCount, .impressions, .profileViews, .reach: return "day"
            case .engagement, .saved, .videoViews, .exits, .replies, .tapsForward, .tapsBack: return ""
            }
        }
    }
}

extension InstagramAPI {
    
    var accountInfoURL: URL {
        requestURL(fields: AccountInfo.CodingKeys.requestFields)
    }
    
    var audienceInfoURL: URL {
        requestURL(for: .insights, metrics: [.audienceGenderAge, .audienceCity])
    }
    
    var insightsURL: URL {
        requestURL(for: .insights, metrics: [.followerCount, .impressions, .profileViews, .reach])
    }
    
    var mediaItemListURL: URL {
        requestURL(for: .media, fields: MediaItem.CodingKeys.requestFields, custom: "&limit=1000")
    }
    
    func mediaItemInsightsURL(mediaItem: MediaItem) -> URL {
        switch mediaItem.productType {
        case .feed:
            let videoViews: [Metric] = mediaItem.mediaType == .image ? [] : [.videoViews]
            return requestURL(id: mediaItem.id, for: .insights, metrics: videoViews + [.reach, .impressions, .engagement, .saved], noPeriod: true)
        case .story:
            return requestURL(id: mediaItem.id, for: .insights, metrics: [.exits, .impressions, .reach, .replies, .tapsForward, .tapsBack], noPeriod: true)
        default:
            fatalError()
        }
    }
    
    private func requestURL(
        id: String? = nil,
        for endpoint: Endpoint? = nil,
        metrics: [Metric] = [],
        noPeriod: Bool = false,
        sinceUntil: (Date, Date)? = nil,
        custom: String? = nil
    ) -> URL {
        requestURL(id: id, for: endpoint, fields: [] as [Metric], metrics: metrics, noPeriod: noPeriod, sinceUntil: sinceUntil, custom: custom)
    }
    
    private func requestURL<Field: RawRepresentable>(
        id: String? = nil,
        for endpoint: Endpoint? = nil,
        fields: [Field] = [],
        metrics: [Metric] = [],
        noPeriod: Bool = false,
        sinceUntil: (Date, Date)? = nil,
        custom: String? = nil
    ) -> URL where Field.RawValue == String {
        var url = host + (id ?? accountID) + (endpoint?.rawValue ?? "") + "?access_token=" + accessToken
        
        if !fields.isEmpty {
            url += "&fields=" + fields.map(\.rawValue).joined(separator: ",")
        }
        
        if !metrics.isEmpty {
            url += "&metric=" + metrics.map(\.rawValue).joined(separator: ",")
            
            if !noPeriod {
                guard Set(metrics.map(\.period)).count == 1 else { fatalError() }
                url += "&period=" + metrics[0].period
            }
        }
        
        if let (since, until) = sinceUntil {
            url += "&since=" + "\(Int(since.timeIntervalSince1970))"
            url += "&until=" + "\(Int(until.timeIntervalSince1970))"
        } else if metrics.contains(where: { [Metric.followerCount, .impressions, .profileViews, .reach].contains($0) }) {
            let since = Date().timeIntervalSince1970 - (28 * 24 * 60 * 60)
            url += "&since=" + "\(Int(since))"
            url += "&until=" + "\(Int(Date().timeIntervalSince1970))"
        }
        
        url += custom ?? ""
        
        return URL(string: url)!
    }
}

