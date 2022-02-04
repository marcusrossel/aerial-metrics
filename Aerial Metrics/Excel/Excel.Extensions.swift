//
//  Excel.Extensions.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import xlsxwriter

extension Value {
    
    static func int(_ int: Int) -> Value { .number(Double(int)) }
    
    static func stringable<S: CustomStringConvertible>(_ string: S) -> Value { .string(string.description) }
}
