//
//  CategoryView.swift
//  MoneyLog
//
//  Created by 박서인 on 8/14/25.
//

import SwiftUI
import SwiftData

struct SelectCategoryView: View {
    @Binding var category: Category?
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var categories: [Category]
    
    @State private var type: TransactionType
    @State private var showingAddCategory = false
    
    
    init(type: TransactionType, category: Binding<Category?>) {
        _type = State(initialValue: type)
        _category = category
    }
        
    
    var body: some View {
        Form {
            if (categories.count != 0) {
                Section(sectionName) {
                    ForEach(filteredCategory, id: \.self) { c in
                        Button {
                            category = c
                            dismiss()
                        } label: {
                            HStack {
                                Text(c.symbol)
                                    .foregroundStyle(.black)
                                Text(c.name)
                                    .foregroundStyle(.black)

                                Spacer()
                                
                                if c == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            
            Section {
                Button("카테고리 추가") {
                    showingAddCategory = true
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("카테고리 선택")
                    .font(.default)
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
        }
    }
    
    private var filteredCategory: [Category] {
        categories.filter { $0.type == type }
    }
    
    private var sectionName: String {
        type == TransactionType.income ? "입금" : "지출"
    }
}

//#Preview {
//    SelectCategoryView(type: .income, category: nil)
//        .modelContainer(PreviewContainer.shared.container)
//}
