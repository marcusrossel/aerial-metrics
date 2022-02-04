//
//  CitiesLayout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

struct CitiesLayout: Layout, Codable {
    
    typealias Field = CitiesField
    typealias Context = Void
    
    var fields: [Field]
    
    private static var defaultFields: [Field] = [.city, .followers]
    
    init(fields: [Field] = defaultFields) {
        self.fields = fields
    }
}
