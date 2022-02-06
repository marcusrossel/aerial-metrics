//
//  SheetView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 04.02.22.
//

import SwiftUI

struct SheetView<L: Layout>: View {
    
    @Binding var layout: L
    
    var body: some View {
        NavigationView {
            List {
                ForEach($layout.fields, id: \.descriptor) { $field in
                    NavigationLink {
                        ColumnStyleView(title: $field.title, titleStyle: $field.titleStyle, fieldStyle: $field.style)
                    } label: {
                        HStack {
                            Text(field.title.replacingOccurrences(of: "-\n", with: "").replacingOccurrences(of: "\n", with: " "))
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .padding(6)
                    }
                }.onMove { indices, newOffset in
                    layout.fields.move(
                        fromOffsets: indices,
                        toOffset: newOffset
                    )
                }
            }
            
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 100))
                .foregroundColor(.secondary)
                .opacity(0.4)
        }
    }
}

