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
    @State private var showingAddEdit: Bool = false
    @State private var type: TransactionType = .expense
    
    var body: some View {
        TabView {
            Tab("요약", systemImage: "text.rectangle") {
                NavigationStack {
                    TransactionSummaryView()
                        .navigationTitle("2025년")
                        .toolbar { addToolbar }
                }
            }
            
            Tab("전체", systemImage: "list.bullet") {
                NavigationStack {
                    TransactionListView()
                        .navigationTitle("2025년 8월")
                        .toolbar { addToolbar }
                }
            }
        }
        .sheet(isPresented: $showingAddEdit) {
            AddEditTransactionView()
        }
    }
    
    @ToolbarContentBuilder
    private var addToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Add Item", systemImage: "plus") {
                showingAddEdit = true
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(PreviewContainer.shared.container)
}
