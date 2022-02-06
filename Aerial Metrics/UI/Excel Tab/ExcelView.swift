//
//  ExcelView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 04.02.22.
//

import SwiftUI

struct ExcelView: View {
    
    @Binding var layouts: Database.ExcelLayouts
    
    @State private var sheet: Sheet = .timeline
    
    var body: some View {
        Group {
            switch sheet {
            case .timeline: SheetView(layout: $layouts.timeline)
            case .posts: SheetView(layout: $layouts.posts)
            case .cities: SheetView(layout: $layouts.cities)
            }
        }
        .toolbar {
            Picker("Sheet", selection: $sheet) {
                ForEach(Sheet.allCases) { sheet in
                    Text(sheet.description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    enum Sheet: Identifiable, CaseIterable {
        
        case timeline
        case posts
        case cities
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .timeline: return "Timeline"
            case .posts: return "Posts"
            case .cities: return "Städte"
            }
        }
    }
}
