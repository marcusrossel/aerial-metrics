//
//  ExcelGeneratorView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import SwiftUI

struct ExcelGeneratorView: View {
    
    @Binding var accessToken: String
    @Binding var accountID: String
    @Binding var database: Database?
    
    @State private var showProgressView = false
    @State private var showSpreadsheetPath = false
    
    @State private var alertTitle: String? = nil
    @State private var alertMessage: String? = nil
    
    private var showAlertBinding: Binding<Bool> {
        Binding {
            alertTitle != nil && alertMessage != nil
        } set: { showAlert in
            guard !showAlert else { fatalError("Alert binding used in unintended way.") }
            alertTitle = nil
            alertTitle = nil
        }
    }
    
    @State private var currentUUID = UUID()
    
    private var currentFilePath: URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .last?
            .appendingPathComponent("Aerial Metrics", isDirectory: true)
            .appendingPathComponent("metrics-\(currentUUID.uuidString.prefix(8)).xlsx")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Erzeugen", action: { Task { await generateSpreadsheet() } })
                    .disabled(accessToken.count < 200 || showProgressView || database == nil)
                    .opacity(showProgressView ? 0 : 1)
                    .overlay { if showProgressView { ProgressView() } }
                
                Spacer()
            }
            
            if showSpreadsheetPath {
                Divider()
                
                HStack {
                    Text(currentFilePath?.path ?? "???")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: openSpreadsheet) {
                        Image(systemName: "doc.text")
                    }
                    
                }
            }
        }
        .alert(alertTitle ?? "", isPresented: showAlertBinding) {
            Button("OK") { showAlertBinding.wrappedValue = false }
        } message: {
            Text(alertMessage ?? "")
        }
    }
    
    private func openSpreadsheet() {
        guard
            let excel = NSWorkspace.shared.urlForApplication(toOpen: .spreadsheet),
            let path = URL(string: "file://" + (currentFilePath?.path ?? "").replacingOccurrences(of: " ", with: "+"))
        else { return }
        
        NSWorkspace.shared.open([path], withApplicationAt: excel, configuration: NSWorkspace.OpenConfiguration())
    }
    
    private func generateSpreadsheet() async {
        showProgressView = true
        defer { showProgressView = false }
        
        currentUUID = UUID()
        guard let filePath = currentFilePath else {
            alertTitle = "Ungültiger Dateipfad"
            alertMessage = ""
            showSpreadsheetPath = false
            return
        }
        
        guard var db = database else {
            showSpreadsheetPath = false
            return
        }
        
        let api = InstagramAPI(accountID: accountID, accessToken: accessToken)

        switch await DatabaseManager.update(database: db, api: api) {
        case let .success(newDB): db = newDB
        case let .failure(error):
            switch error {
            case .malformedAccessToken:
                alertTitle = "Ungültiger Access Token"
                alertMessage = "Es kann sein, dass der Access Token während der Anfrage abgelaufen ist."
            case let .decoding(message):
                alertTitle = "Fehlerhafte Daten"
                alertMessage = message
            case let .unknown(message):
                alertTitle = "Unbekannter Fehler"
                alertMessage = message
            }
            showSpreadsheetPath = false
            return
        }
        
        switch DatabaseManager.write(database: db) {
        case .invalidURL:
            alertTitle = "Ungültiger Dateipfad"
            alertMessage = ""
        case let .encoding(message: message):
            alertTitle = "Fehlerhafte Daten"
            alertMessage = message
        case let .unknown(message: message):
            alertTitle = "Unbekannter Fehler"
            alertMessage = message
        case .none:
            break
        }
        
        Excel.create(for: db, at: filePath)
        self.database = db
        showSpreadsheetPath = true
    }
}
