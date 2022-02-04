//
//  Style.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 30.01.22.
//

import xlsxwriter

enum Style: CaseIterable {
    case headerBlue
    case headerGreen
    case headerOrange
    case data
    case url
    case long
    case rightAligned
}

extension Format {
    
    init(style: Style, workbook: Workbook) {
        switch style {
        case .headerBlue: self = workbook.addFormat().center().bold().background(argb: 0xB3E6FF).border(style: .thin)
        case .headerGreen: self = workbook.addFormat().center().bold().background(argb: 0x98DA8D).border(style: .thin)
        case .headerOrange: self = workbook.addFormat().center().bold().background(argb: 0xEFBA5E).border(style: .thin)
        case .data: self = workbook.addFormat().center()
        case .url: self = workbook.addFormat().center().font(color: .blue).italic()
        case .long: self = workbook.addFormat().align(horizontal: .left).align(vertical: .center)
        case .rightAligned: self = workbook.addFormat().align(horizontal: .right).align(vertical: .center)
        }
    }
}


