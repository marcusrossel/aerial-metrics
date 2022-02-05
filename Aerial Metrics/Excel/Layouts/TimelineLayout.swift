//
//  TimelineLayout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

struct TimelineLayout: Layout, Codable {
    
    typealias Descriptor = TimelineDescriptor
    typealias Context = Void
    
    var fields: [Field<Descriptor>]
    
    private static var defaultFields: [Field] =
        ([Descriptor.date, .followers, .follows, .mediaCount, .newFollowers, .impressions, .profileViews, .reach] +
         AudienceInfo.Gender.allCases.map(Descriptor.gender(gender:)))
        .map(Field.init)
    
    init(fields: [Field<Descriptor>] = defaultFields) {
        self.fields = fields
    }
}

