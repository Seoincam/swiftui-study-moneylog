//
//  AddCategoryView.swift
//  MoneyLog
//
//  Created by 박서인 on 8/15/25.
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: TransactionType = TransactionType.income

    @State private var symbol: String = ""
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("종류", selection: $type) {
                        Text("입금").tag(TransactionType.income)
                        Text("출금").tag(TransactionType.expense)
                    }
                }
                
                Section {
                    TextField("기호", text: $symbol)
                    TextField("이름", text: $name)
                }
            }
            .toolbar { toolbar }
        }
        
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            
        }
        
        ToolbarItem(placement: .principal) {
            Text("카테고리 추가")
                .font(.default)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button("Add Category", systemImage: "checkmark") {
                addCategory()
                dismiss()
            }
            .disabled(!canAdd)
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var canAdd: Bool {
        symbol != "" && name != ""
    }
    
    private func addCategory() {
        let category = Category(symbol: symbol, name: name, type: type)
        context.insert(category)
    }
}

#Preview {
    AddCategoryView()
}
