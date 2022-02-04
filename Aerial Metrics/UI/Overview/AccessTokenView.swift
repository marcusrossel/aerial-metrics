//
//  AccessTokenView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import SwiftUI

struct AccessTokenView: View {
    
    @Binding var accessToken: String
    
    @State private var showGraphAPIExplorer = false
    private let apiExplorerURL = URL(string: "https://developers.facebook.com/tools/explorer/")!
    
    var body: some View {
        VStack {
            if showGraphAPIExplorer {
                WebView(url: apiExplorerURL)
                    .frame(height: 250)
                    .cornerRadius(6)
            }
            
            HStack {
                TextField("Access Token", text: $accessToken)
                    .background(Color(NSColor.windowBackgroundColor).cornerRadius(6))
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    showGraphAPIExplorer.toggle()
                } label: {
                    Image(systemName: "safari")
                }
            }
        }
        
    }
}
