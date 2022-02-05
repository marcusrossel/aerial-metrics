//
//  Excel.Extensions.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import xlsxwriter
import SwiftUI

extension Value {
    
    static func int(_ int: Int) -> Value { .number(Double(int)) }
    
    static func stringable<S: CustomStringConvertible>(_ string: S) -> Value { .string(string.description) }
}

extension Format {
    
    init(for style: Style, workbook: Workbook) {
        let format = workbook.addFormat()
        
        if let vAlignment = style.verticalAlignment                           { format.align(vertical: vAlignment) }
        if let hAlignment = style.horizontalAlignment                         { format.align(horizontal: hAlignment) }
        if let bgColor = style.backgroundColor, let c = Color(color: bgColor) { format.background(color: c) }
        if let fColor = style.fontColor,        let c = Color(color: fColor)  { format.font(color: c) }
        if style.bold                                                         { format.bold() }
        if style.italic                                                       { format.italic() }
        if let border = style.border                                          { format.border(style: border) }

        self = format
    }
}
