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
            SheetView(layout: $layouts.timeline)
                .tabItem { Text("Timeline") }
            
            SheetView(layout: $layouts.posts)
                .tabItem { Text("Posts") }
            
            SheetView(layout: $layouts.cities)
                .tabItem { Text("Städte") }
        }
        .padding()
    }
}
