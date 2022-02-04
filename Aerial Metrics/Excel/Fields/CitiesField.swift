//
//  CitiesField.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter

enum CitiesField: Field, Codable {
    
    typealias Content = (city: String, followers: Int)
    typealias Context = Void
    
    case city
    case followers
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .city:      return "Stadt"
        case .followers: return "Follower"
        }
    }
    
    var style: Style? {
        switch self {
        case .city:      return .verticalAlignment(.center).horizontalAlignment(.left)
        case .followers: return .centered
        }
    }
    
    var titleStyle: Style? { .header }
    
    var width: Double? {
        switch self {
        case .city:      return 30
        case .followers: return 7
        }
    }
    
    func value(for content: Content, context: Context) -> Value? {
        guard content.followers > 1 else { return nil }
        
        switch self {
        case .city:      return .string(content.city)
        case .followers: return .int(content.followers)
        }
    }
}
