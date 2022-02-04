//
//  DatabaseView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import SwiftUI

struct DatabaseView: View {
    
    @Binding var database: Database?
    
    @State private var alertTitle: String?
    @State private var alertMessage: String?
    
    private var showAlertBinding: Binding<Bool> {
        Binding {
            alertTitle != nil && alertMessage != nil
        } set: { showAlert in
            guard !showAlert else { fatalError("Alert binding used in unintended way.") }
            alertTitle = nil
            alertTitle = nil
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if database == nil {
                Button("Create", action: createDatabase)
                
                Spacer()
            } else {
                Button {
                    guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
                    NSWorkspace.shared.open(documents)
                } label: {
                    Image(systemName: "folder")
                }
                
                Text(DatabaseManager.filePath?.path ?? "???")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
        .alert(alertTitle ?? "", isPresented: showAlertBinding) {
            Button("OK") { showAlertBinding.wrappedValue = false }
        } message: {
            Text(alertMessage ?? "")
        }
    }
    
    private func createDatabase() {
        switch DatabaseManager.createDatabase() {
        case .invalidURL:
            alertTitle = "Ungültiger Dateipfad"
            alertMessage = ""
        case .unknown(let message):
            alertTitle = "Unbekannter Fehler"
            alertMessage = message
        case .none:
            database = Database()
        }
    }
}
