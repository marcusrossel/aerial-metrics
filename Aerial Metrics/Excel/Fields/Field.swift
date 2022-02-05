//
//  Field.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter

struct Field<Descriptor: FieldDescriptor>: Codable, Hashable {
    
    let descriptor: Descriptor
    var title: String
    var style: Style?
    var titleStyle: Style?
    let titleMerge: Int?
    let subfields: [Field<Descriptor>]
    
    init(_ descriptor: Descriptor) {
        self.descriptor = descriptor
        self.title = descriptor.title
        self.style = descriptor.style
        self.titleStyle = descriptor.titleStyle
        self.titleMerge = descriptor.titleMerge
        self.subfields = descriptor.subfields
    }
    
    func value(for content: Descriptor.Content, context: Descriptor.Context) -> Value? {
        descriptor.value(for: content, context: context)
    }
    
    func merge(for content: Descriptor.Content, context: Descriptor.Context) -> Int? {
        descriptor.merge(for: content, context: context)
    }
}

protocol FieldDescriptor: Identifiable, Hashable, Codable {
    
    associatedtype Content
    associatedtype Context
    
    var style: Style? { get }
    var title: String { get }
    var titleStyle: Style? { get }
    var titleMerge: Int? { get }
    
    func value(for content: Content, context: Context) -> Value?
    func merge(for content: Content, context: Context) -> Int?
    
    var subfields: [Field<Self>] { get }
}

extension FieldDescriptor {
    
    var style: Style? { nil }
    var titleStyle: Style? { nil }
    var titleMerge: Int? { nil }
    func merge(for content: Content, context: Context) -> Int? { nil }
    var subfields: [Field<Self>] { [] }
}
