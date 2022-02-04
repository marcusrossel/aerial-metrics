//
//  Field.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter

protocol Field: Identifiable {
    
    associatedtype Content
    associatedtype Context
    
    var style: Style? { get }
    var width: Double? { get }
    var title: String { get }
    var titleStyle: Style? { get }
    var titleMerge: Int? { get }
    
    func value(for content: Content, context: Context) -> Value?
    func merge(for content: Content, context: Context) -> Int?
    
    var subfields: [Self] { get }
}

extension Field {
    
    var style: Style? { nil }
    var width: Double? { nil }
    var titleStyle: Style? { nil }
    var titleMerge: Int? { nil }
    func merge(for content: Content, context: Context) -> Int? { nil }
    var subfields: [Self] { [] }
}
