//
//  Overview.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 04.02.22.
//

import SwiftUI

struct Overview: View {
    
    @Binding var database: Database?
    
    @State private var accessToken = ""
    @State private var accountID = "17841444051776273"

    var body: some View {
        VStack(spacing: 16) {
            GroupBox(label: Label("Access Token", systemImage: "lock.fill").font(.headline)) {
                AccessTokenView(accessToken: $accessToken)
                    .padding(12)
            }
            .padding(8)
            
            GroupBox(label: Label("Excel Tabelle", systemImage: "chart.bar.xaxis").font(.headline)) {
                ExcelGeneratorView(accessToken: $accessToken, accountID: $accountID, database: $database)
                    .padding(12)
            }
            .padding(8)
            
            GroupBox(label: Label("Datenbank", systemImage: "internaldrive.fill").font(.headline)) {
                DatabaseView(database: $database)
                    .padding(12)
            }
            .padding(8)
        }
    }
}
