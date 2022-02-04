//
//  Style.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter
import SwiftUI

enum Style: Hashable {
    
    typealias Color = SwiftUI.Color
    typealias HorizontalAlignment = xlsxwriter.HorizontalAlignment
    typealias VerticalAlignment = xlsxwriter.VerticalAlignment
    
    case horizontalAlignment(HorizontalAlignment)
    case verticalAlignment(VerticalAlignment)
    case backgroundColor(Color)
    case fontColor(xlsxwriter.Color)
    case bold
    case italic
    case border(Border)
    case compound([Style])
    
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> Style { .compound([self, .horizontalAlignment(alignment)]) }
    func verticalAlignment(_ alignment: VerticalAlignment) -> Style { .compound([self, .verticalAlignment(alignment)]) }
    func backgroundColor(_ color: Color) -> Style { .compound([self, .backgroundColor(color)]) }
    func fontColor(_ color: xlsxwriter.Color) -> Style { .compound([self, .fontColor(color)]) }
    func bold() -> Style { .compound([self, .bold]) }
    func italic() -> Style { .compound([self, .italic]) }
    func border(_ border: Border) -> Style { .compound([self, .border(border)]) }
    
    static var centered: Style { .horizontalAlignment(.center).verticalAlignment(.center) }
    static var header: Style { .centered.bold().border(.thin) }
    static var url: Style { .centered.fontColor(.blue).italic() }
    
    var flattened: [Style] {
        switch self {
        case let .compound(styles): return styles.flatMap(\.flattened)
        default: return [self]
        }
    }
}


