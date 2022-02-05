//
//  CitiesLayout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

struct CitiesLayout: Layout, Codable {
    
    typealias Descriptor = CitiesDescriptor
    typealias Context = Void
    
    var fields: [Field<Descriptor>]
    
    private static var defaultFields: [Field<Descriptor>] = [Descriptor.city, .followers].map(Field.init)
    
    init(fields: [Field<Descriptor>] = defaultFields) {
        self.fields = fields
    }
}
