//
//  ContentView.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 25.01.22.
//

import SwiftUI

struct ContentView: View {
    
    private let backgroundGradient = LinearGradient(colors: [Color("AerialMagenta"), Color("AerialBlue")], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    
    @State private var selectedTab: Tab? = .overview
    @State private var database: Database?
    
    // This binding should only be used when it is clear that `database != nil`.
    // E.g. the `ExcelView` and `ReelsView` are only shown, when this condition is fulfilled.
    private var unsafeDatabaseBinding: Binding<Database> {
        Binding { database! } set: { database = $0 }
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
                    NavigationLink(tag: Tab.reels, selection: $selectedTab) {
                        ReelsView(database: unsafeDatabaseBinding)
                    } label: {
                        Label(Tab.reels.description, systemImage: Tab.reels.systemImage)
                    }
                    
                    NavigationLink(tag: Tab.excel, selection: $selectedTab) {
                        ExcelView(layouts: unsafeDatabaseBinding.excelLayouts)
                    } label: {
                        Label(Tab.excel.description, systemImage: Tab.excel.systemImage)
                    }
                }
            }
            .listStyle(.sidebar)
        }
        .background(backgroundGradient)
        .navigationTitle(selectedTab?.title ?? "Aerial Metrics")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.leading")
                }
            }
        }
        .onAppear(perform: loadDatabase)
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
            case .unknown(let message):
                print("Load Database: Unknown Error: \(message)")
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
        case reels
        case excel
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .overview: return "Overview"
            case .reels: return "Reels"
            case .excel: return "Excel"
            }
        }
        
        var systemImage: String {
            switch self {
            case .overview: return "house"
            case .reels: return "film"
            case .excel: return "chart.bar.xaxis"
            }
        }
        
        var title: String {
            description
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
