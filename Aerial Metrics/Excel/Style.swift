//
//  Style.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter
import SwiftUI

struct Style: Hashable, Codable {
    
    typealias Color = SwiftUI.Color
    typealias HorizontalAlignment = xlsxwriter.HorizontalAlignment
    typealias VerticalAlignment = xlsxwriter.VerticalAlignment
    
    var horizontalAlignment: HorizontalAlignment?
    var verticalAlignment: VerticalAlignment?
    var backgroundColor: Color?
    var fontColor: Color?
    var bold: Bool
    var italic: Bool
    var border: Border?
    var width: Double?
    
    private init(horizontalAlignment: HorizontalAlignment? = nil, verticalAlignment: VerticalAlignment? = nil, backgroundColor: Color? = nil, fontColor: Color? = nil, bold: Bool = false, italic: Bool = false, border: Border? = nil, width: Double? = nil) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.backgroundColor = backgroundColor
        self.fontColor = fontColor
        self.bold = bold
        self.italic = italic
        self.border = border
        self.width = width
    }

    func horizontal(alignment: HorizontalAlignment?) -> Style { var new = self; new.horizontalAlignment = alignment; return new }
    func vertical(alignment: VerticalAlignment?) -> Style     { var new = self; new.verticalAlignment = alignment; return new }
    func background(color: Color?) -> Style                   { var new = self; new.backgroundColor = color; return new }
    func font(color: Color?) -> Style                         { var new = self; new.fontColor = color; return new }
    func bold(_ set: Bool = true) -> Style                    { var new = self; new.bold = set; return new }
    func italic(_ set: Bool = true) -> Style                  { var new = self; new.italic = set; return new }
    func border(_ border: Border?) -> Style                   { var new = self; new.border = border; return new }
    func width(_ width: Double?) -> Style                     { var new = self; new.width = width; return new }
    
    static func horizontal(alignment: HorizontalAlignment?) -> Style { Style().horizontal(alignment: alignment) }
    static func vertical(alignment: VerticalAlignment?) -> Style     { Style().vertical(alignment: alignment) }
    static func background(color: Color?) -> Style                   { Style().background(color: color) }
    static func font(color: Color?) -> Style                         { Style().font(color: color) }
    static func bold(_ set: Bool = true) -> Style                    { Style().bold(set) }
    static func italic(_ set: Bool = true) -> Style                  { Style().italic(set) }
    static func border(_ border: Border?) -> Style                   { Style().border(border) }
    static func width(_ width: Double?) -> Style                     { Style().width(width) }
    
    func centered() -> Style { return self.vertical(alignment: .center).horizontal(alignment: .center) }
    static var centered: Style { Style().centered() }
    
    static var header: Style { .centered.bold().border(.thin).background(color: .red) }
    static var url: Style { .centered.font(color: .blue).italic() }
}

extension SwiftUI.Color: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(xlsxwriter.Color(color: self))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let xlsxColor = try container.decode(xlsxwriter.Color.self)
        self = xlsxColor.swiftUIColor
    }
}
