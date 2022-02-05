//
//  Layout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

protocol Layout {
    
    associatedtype Descriptor: FieldDescriptor
    associatedtype Context
    
    var fields: [Field<Descriptor>] { get set }
    
    func fieldContext(for context: Context, contentIndex: Int) -> Descriptor.Context
    
    var hideSuperfluousColumns: Bool { get }
    var defaultColumnCount: Int { get }
}

extension Layout {
    var hideSuperfluousColumns: Bool { true }
    var defaultColumnCount: Int { 5 }
}

extension Layout where Descriptor.Context == Void {
    func fieldContext(for context: Context, contentIndex: Int) -> Descriptor.Context { () }
}

