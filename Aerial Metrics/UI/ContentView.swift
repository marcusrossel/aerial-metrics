//
//  ContentView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 25.01.22.
//

import SwiftUI

struct ContentView: View {
    
    private let backgroundGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.6598907709, green: 0.475697577, blue: 0.63261199, alpha: 1)), Color(#colorLiteral(red: 0.2005341053, green: 0.6120080352, blue: 0.6858652234, alpha: 1))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    
    @State private var selectedTab: Tab? = .overview
    @State private var database: Database?
    
    // This binding should only be used when it is clear that `database != nil`.
    // E.g. the `ExcelView` is only shown, when this condition is fulfilled.
    private var unsafeLayoutsBinding: Binding<Database.ExcelLayouts> {
        Binding { database!.excelLayouts } set: { database?.excelLayouts = $0 }
    }
    
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
        NavigationView {
            List {
                NavigationLink(tag: Tab.overview, selection: $selectedTab) {
                    Overview(database: $database)
                        .padding(.horizontal)
                } label: {
                    Label(Tab.overview.description, systemImage: Tab.overview.systemImage)
                }
                
                if database != nil {
                    NavigationLink(tag: Tab.excel, selection: $selectedTab) {
                        ExcelView(layouts: unsafeLayoutsBinding)
                    } label: {
                        Label(Tab.excel.description, systemImage: Tab.excel.systemImage)
                    }
                }
            }
            .listStyle(.sidebar)
        }
        .navigationTitle(selectedTab?.title ?? "Aerial Metrics")
        .background(backgroundGradient)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.leading")
                }
            }
        }.onAppear(perform: loadDatabase)
    }
    
    private func loadDatabase() {
        switch DatabaseManager.loadDatabase() {
        case .success(let database): self.database = database
        case .failure(let error):
            switch error {
            case .invalidURL:
                alertTitle = "Ungültiger Dateipfad"
                alertMessage = ""
            case .decoding(let message):
                alertTitle = "Fehlerhafte Daten"
                alertMessage = message
            case .unknown:
                break
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

extension ContentView {
    
    enum Tab: Identifiable, CustomStringConvertible {
        
        case overview
        case excel
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .overview: return "Overview"
            case .excel: return "Excel"
            }
        }
        
        var systemImage: String {
            switch self {
            case .overview: return "house"
            case .excel: return "chart.bar.xaxis"
            }
        }
        
        var title: String {
            switch self {
            case .overview: return "Aerial Metrics"
            case .excel: return "Layout"
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
