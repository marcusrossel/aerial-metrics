//
//  TimelineLayout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

struct TimelineLayout: Layout, Codable {
    
    typealias Field = TimelineField
    typealias Context = Void
    
    var fields: [Field]
    
    private static var defaultFields: [Field] =
        [.date, .followers, .follows, .mediaCount, .newFollowers, .impressions, .profileViews, .reach] +
        AudienceInfo.Gender.allCases.map(Field.gender(gender:))
    
    init(fields: [Field] = defaultFields) {
        self.fields = fields
    }
}

