//
//  ColumnStyleView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 05.02.22.
//

import SwiftUI

struct ColumnStyleView: View {
    
    @Binding var title: String
    @Binding var titleStyle: Style?
    @Binding var fieldStyle: Style?
    
    private var widthToggleBinding: Binding<Bool> {
        Binding { titleStyle?.width != nil } set: { titleStyle?.width = $0 ? 0.0 : nil }
    }
    
    private var widthBinding: Binding<Double> {
        Binding { titleStyle?.width ?? 0 } set: { titleStyle?.width = $0 }
    }
    
    var body: some View {
        VStack(spacing: 48) {
            HStack(alignment: .top, spacing: 48) {
                StyleView(style: $titleStyle) {
                    Label("Kopf", systemImage: "rectangle.portrait.topthird.inset.filled")
                }
                
                StyleView(style: $fieldStyle) {
                    Label("Felder", systemImage: "rectangle.portrait.bottomhalf.inset.filled")
                }
            }
            
            topView
            
            Spacer()
        }
        .padding(12)
    }
    
    @ViewBuilder private var topView: some View {
        VStack(alignment: .leading) {
            Label("Allgemein", systemImage: "rectangle.portrait")
                .font(.headline)
            
            Divider()
            
            HStack {
                Toggle("Titel", isOn: .constant(true))
                TextField("Titel", text: $title)
            }
            
            HStack {
                Toggle("Breite", isOn: widthToggleBinding)
                
                Slider(value: widthBinding, in: 0...100) {
                    Text("\(Int(titleStyle?.width ?? 0))")
                        .frame(width: 25)
                }
            }
            .frame(height: 28)
        }
    }
}

