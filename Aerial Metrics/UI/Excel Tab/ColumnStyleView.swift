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
        VStack(spacing: 16) {
            topView
            
            HStack(alignment: .top, spacing: 16) {
                StyleView(style: $titleStyle) {
                    Label("Header", systemImage: "rectangle.portrait.topthird.inset.filled")
                }
                
                StyleView(style: $fieldStyle) {
                    Label("Felder", systemImage: "rectangle.portrait.bottomhalf.inset.filled")
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder private var topView: some View {
        GroupBox {
            VStack(alignment: .leading) {
                HStack {
                    Toggle("Titel", isOn: .constant(true))
                    TextField("Titel", text: $title)
                }
                .frame(height: 25)
                
                HStack {
                    Toggle("Breite", isOn: widthToggleBinding)
                    
                    Slider(value: widthBinding, in: 0...100) {
                        Text("\(Int(titleStyle?.width ?? 0))")
                            .monospacedDigit()
                            .frame(width: 25, alignment: .trailing)
                    }
                }
                .frame(height: 25)
            }
            .padding(12)
        } label: {
            Label("Allgemein", systemImage: "rectangle.portrait")
                .font(.headline)
        }
    }
}

