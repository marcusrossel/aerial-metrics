//
//  Layout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

protocol Layout {
    
    associatedtype Field: Aerial_Metrics.Field
    associatedtype Context
    
    var fields: [Field] { get set }
    
    func fieldContext(for context: Context, contentIndex: Int) -> Field.Context
    
    var hideSuperfluousColumns: Bool { get }
    var defaultColumnCount: Int { get }
}

extension Layout {
    var hideSuperfluousColumns: Bool { true }
    var defaultColumnCount: Int { 5 }
}

extension Layout where Field.Context == Void {
    func fieldContext(for context: Context, contentIndex: Int) -> Field.Context { () }
}

