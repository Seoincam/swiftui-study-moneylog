//
//  ContentView.swift
//  MoneyLog
//
//  Created by 박서인 on 8/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingAdd = false
    
    var body: some View {
        TabView {
            Tab("요약", systemImage: "text.rectangle") {
                NavigationStack {
                    TransactionSummaryView()
                        .navigationTitle("2025년")
                        .toolbar {
                            ToolbarItem { addButton }
                        }
                }
            }
            
            Tab("전체", systemImage: "list.bullet") {
                NavigationStack {
                    TransactionListView()
                        .navigationTitle("2025년 8월")
                        .toolbar {
                            ToolbarItem { addButton }
                        }
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddEditTransactionView()
        }
    }
    
    private var addButton: some View {
        Button("추가", systemImage: "plus") {
            showingAdd = true
        }
    }
    
    private var editButton: some View {
        Button("편집") {
            
        }
    }
}


#Preview("Preview Datas") {
    ContentView()
        .modelContainer(PreviewContainer.shared.container)
}

#Preview("None Data") {
    ContentView()
        .modelContainer(for: Transaction.self, isAutosaveEnabled: false)
}
