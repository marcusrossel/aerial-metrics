//
//  CitiesField.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter

// TODO: Rename the "Field Descriptor" to something else.
// Perhaps you can rename "field" to column in the process or something.

enum CitiesDescriptor: FieldDescriptor {
    
    typealias Content = (city: String, followers: Int)
    typealias Context = Void
    
    case city
    case followers
    
    var id: Self { self }

    var title: String {
        switch self {
        case .city: return "Stadt"
        case .followers: return "Follower"
        }
    }
    
    var style: Style? {
        switch self {
        case .city: return .vertical(alignment: .center).horizontal(alignment: .left)
        case .followers: return .centered
        }
    }
    
    var titleStyle: Style? {
        switch self {
        case .city: return .header.width(30)
        case .followers: return .header.width(7)
        }
    }
    
    func value(for content: Content, context: Context) -> Value? {
        guard content.followers > 1 else { return nil }
        
        switch self {
        case .city: return .string(content.city)
        case .followers: return .int(content.followers)
        }
    }
}
