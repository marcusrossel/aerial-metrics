//
//  Excel.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 23.01.22.
//

import xlsxwriter
import Foundation

enum Excel {
    
    private static let rowHeight = 18.0
    
    static func create(for database: Database, at path: URL) {
        let workbook = Workbook(name: path.path)
        
        let sheets = (
            timeline:   workbook.addWorksheet(name: "Timeline").set_default(row_height: rowHeight),
            mediaItems: workbook.addWorksheet(name: "Posts"   ).set_default(row_height: rowHeight),
            cities:     workbook.addWorksheet(name: "Städte"  ).set_default(row_height: rowHeight)
        )

        let formats = formats(for: database.excelLayouts, workbook: workbook)

        write(layout: database.excelLayouts.timeline, contents: Timeline(for: database).entries, to: sheets.timeline, context: (), formats: formats)
        write(mediaItems: database.groupedMediaItems, to: sheets.mediaItems, layout: database.excelLayouts.posts, formats: formats)
        
        if let cities = database.audienceInfos.last?.cities {
            write(layout: database.excelLayouts.cities, contents: cities, to: sheets.cities, context: (), formats: formats)
        }
        
        workbook.close()
    }
    
    private static func write(mediaItems: [[MediaItem]], to sheet: Worksheet, layout: PostsLayout, formats: [Style: Format]) {
        let itemTimelines = mediaItems.map { $0.sorted { $0.lastUpdate > $1.lastUpdate } }
            
        var row = 0
        for (timelineIndex, itemTimeline) in itemTimelines.enumerated() {
            let context = PostsLayout.Context(
                postNumber: itemTimelines.count - timelineIndex,
                contents: Array(itemTimeline)
            )
            
            row = write(layout: layout, contents: Array(itemTimeline), to: sheet, row: row, writeHeader: timelineIndex == 0, context: context, formats: formats)
        }
    }
    
    private static func formats(for layouts: Database.ExcelLayouts, workbook: Workbook) -> [Style: Format] {
        var styles: [Style] =
            layouts.timeline.fields.compactMap(\.style) +
            layouts.timeline.fields.compactMap(\.titleStyle) 
        styles +=
            layouts.posts.fields.compactMap(\.style) +
            layouts.posts.fields.compactMap(\.titleStyle)
        styles +=
            layouts.cities.fields.compactMap(\.style) +
            layouts.cities.fields.compactMap(\.titleStyle)

        var formats: [Style: Format] = [:]
        styles.uniqued().forEach { style in formats[style] = Format(for: style, workbook: workbook) }
        
        return formats
    }
    
    @discardableResult
    private static func write<L: Layout>(
        layout: L,
        contents: [L.Descriptor.Content],
        to sheet: Worksheet,
        row: Int = 0,
        writeHeader: Bool = true,
        context: L.Context,
        formats: [Style: Format]
    ) -> Int {
        var row = row
        
        if writeHeader {
            let titleEndRow = layout.fields.reduce(row) { result, next in
                guard let titleMerge = next.titleMerge else { return result }
                return max(result, row + titleMerge)
            }
            
            func headerWriter(fields: [Field<L.Descriptor>], subfieldDepth: Int, column: Int) {
                var column = column
                for field in fields {
                    let format = field.titleStyle.flatMap { formats[$0] }
                    
                    let merge = field.titleMerge ?? 0
                    let subfieldColumnOffset = field.subfields.count > 1 ? (field.subfields.count - 1) : 0
                    
                    if merge == 0 && subfieldColumnOffset == 0 {
                        sheet.write(.string(field.title), [subfieldDepth, column], format: format)
                    } else {
                        sheet.merge(range: [subfieldDepth, column, subfieldDepth + merge, column + subfieldColumnOffset], string: field.title, format: format)
                    }
                    
                    if let width = field.titleStyle?.width {
                        sheet.column([column, column], width: width)
                    }
                    
                    headerWriter(fields: field.subfields, subfieldDepth: subfieldDepth + 1, column: column)
                    
                    column = column + subfieldColumnOffset + 1
                }
            }
            
            headerWriter(fields: layout.fields, subfieldDepth: 0, column: 0)
            
            row = titleEndRow
        }
        
        for (offset, content) in contents.enumerated() {
            row += 1
            let fieldContext = layout.fieldContext(for: context, contentIndex: offset)
            
            func dataWriter(fields: [Field<L.Descriptor>], column: inout Int) {
                for field in fields {
                    guard field.subfields.isEmpty else {
                        dataWriter(fields: field.subfields, column: &column)
                        continue
                    }
                    
                    if let merge = field.merge(for: content, context: fieldContext) {
                        sheet.merge(range: [row, column, row + merge, column], string: "")
                    }
                
                    if let value = field.value(for: content, context: fieldContext) {
                        let format = field.style.flatMap { formats[$0] }
                        sheet.write(value, [row, column], format: format)
                    }
                    
                    column += 1
                }
            }
            
            var column = 0
            dataWriter(fields: layout.fields, column: &column)
        }
        
        if layout.hideSuperfluousColumns && layout.fields.count < layout.defaultColumnCount {
            (layout.fields.count..<layout.defaultColumnCount).forEach { sheet.hide_columns($0) }
        }
        
        return row
    }
}
