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
        
        for option in style.flattened {
            switch option {
            case .horizontalAlignment(let alignment): format.align(horizontal: alignment)
            case .verticalAlignment(let alignment):   format.align(vertical: alignment)
            case .backgroundColor(let color):         format.background(argb: color.argb)
            case .fontColor(let color):               format.font(color: color)
            case .bold:                               format.bold()
            case .italic:                             format.italic()
            case .border(let border):                 format.border(style: border)
            case .compound:                           fatalError("Unreachable")
            }
        }
        
        self = format
    }
}

extension Style.Color {
    
    var argb: UInt32 {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)

        var result: UInt32 = 0
        result += UInt32((a * 255.0).rounded()) << (3 * 8)
        result += UInt32((r * 255.0).rounded()) << (2 * 8)
        result += UInt32((g * 255.0).rounded()) << (1 * 8)
        result += UInt32((b * 255.0).rounded()) << (0 * 8)
        
        return result
    }
}
