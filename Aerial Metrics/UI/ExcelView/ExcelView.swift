//
//  ExcelView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 04.02.22.
//

import SwiftUI

struct ExcelView: View {
    
    @Binding var layouts: Database.ExcelLayouts

    var body: some View {
        TabView {
            ColumnReorderingView(layout: $layouts.timeline)
                .tabItem { Text("Timeline") }
            
            ColumnReorderingView(layout: $layouts.posts)
                .tabItem { Text("Posts") }
            
            ColumnReorderingView(layout: $layouts.cities)
                .tabItem { Text("Städte") }
        }
        .padding()
    }
}
