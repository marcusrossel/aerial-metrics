//
//  StyleView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 05.02.22.
//

import SwiftUI

struct StyleView<Title: View, Icon: View>: View {
    
    @Binding var style: Style?
    
    @ViewBuilder let label: () -> Label<Title, Icon>
    
    private var boldBinding: Binding<Bool> {
        Binding { style?.bold == true } set: { style?.bold = $0 }
    }
    
    private var italicBinding: Binding<Bool> {
        Binding { style?.italic == true } set: { style?.italic = $0 }
    }
    
    private var backgroundColorToggleBinding: Binding<Bool> {
        Binding { style?.backgroundColor != nil } set: { style?.backgroundColor = $0 ? .clear : nil }
    }
    
    private var backgroundColorBinding: Binding<Color> {
        Binding { style?.backgroundColor ?? .clear } set: { style?.backgroundColor = $0 }
    }
    
    private var fontColorToggleBinding: Binding<Bool> {
        Binding { style?.fontColor != nil } set: { style?.fontColor = $0 ? .clear : nil }
    }
    
    private var fontColorBinding: Binding<Color> {
        Binding { style?.fontColor ?? .clear } set: { style?.fontColor = $0 }
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Toggle("Fett", isOn: boldBinding)
                            .frame(height: 25)
                        
                        Toggle("Kursiv", isOn: italicBinding)
                            .frame(height: 25)
                        
                        HStack {
                            Toggle("Hintergrund", isOn: backgroundColorToggleBinding)
                                
                            ColorPicker("Hintergrund", selection: backgroundColorBinding)
                                .labelsHidden()
                                .disabled(style?.backgroundColor == nil)
                                .opacity(style?.backgroundColor == nil ? 0 : 1)
                        }
                        .frame(height: 25)
                        
                        HStack {
                            Toggle("Textfarbe", isOn: fontColorToggleBinding)
                                
                            ColorPicker("Textfarbe", selection: fontColorBinding)
                                .labelsHidden()
                                .disabled(style?.backgroundColor == nil)
                                .opacity(style?.fontColor == nil ? 0 : 1)
                        }
                        .frame(height: 25)
                    }
                    
                    Spacer()
                }
            }
            .padding(12)
        } label: {
            label().font(.headline)
        }
    }
}

