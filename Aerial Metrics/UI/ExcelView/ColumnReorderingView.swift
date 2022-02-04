//
//  ColumnReorderingView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 04.02.22.
//

import SwiftUI

struct ColumnReorderingView<L: Layout>: View {
    
    @Binding var layout: L
    
    var body: some View {
        List {
            ForEach(layout.fields) { field in
                HStack {
                    Text(field.title.replacingOccurrences(of: "-\n", with: "").replacingOccurrences(of: "\n", with: " "))
                    Spacer()
                }
                .padding(6)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            }.onMove { indices, newOffset in
                layout.fields.move(
                    fromOffsets: indices,
                    toOffset: newOffset
                )
            }
        }
        .clearBackground()
    }
}

