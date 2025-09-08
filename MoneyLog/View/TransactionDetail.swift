//
//  TransactionDetail.swift
//  MoneyLog
//
//  Created by 박서인 on 9/7/25.
//

import SwiftUI

struct TransactionDetail: View {
    let transaction: Transaction
    
    @State private var showingEdit = false
        
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("종류")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(transaction.type == TransactionType.income ? "입금" : "출금")
                }
                
                HStack {
                    Text("금액")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(transaction.amount, format: WonStyleInt())
                        .font(.title2)
                        .foregroundStyle(transaction.type == TransactionType.income ? .red : .blue)
                }
            }
            
            Section("세부사항") {
                HStack {
                    Image(systemName: "list.bullet")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text("카테고리")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(transaction.category.symbol)
                    Text(transaction.category.name)
                }
                
                if let note = transaction.note {
                    HStack {
                        Image(systemName: "text.bubble")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text("설명")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(note)
                    }
                }
            }
            
            Section {
                if let date = transaction.date {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text("날짜")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(date.formatted(
                            Date.FormatStyle()
                                .locale(Locale(identifier: "ko"))
                                .year()
                                .month()
                                .day()
                                .weekday(.wide)
                        ))
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem { editButton }
            ToolbarSpacer(.fixed)
            ToolbarItem { deleteButton }
        }
        .sheet(isPresented: $showingEdit) {
            EditTransactionView(transaction: transaction)
        }
    }
    
    // MARK: - Buttons
    private var editButton: some View {
        Button("편집") {
            showingEdit = true
        }
    }
    
    private var deleteButton: some View {
        Button {
            
        } label: {
            Text("삭제")
                .foregroundStyle(.red)
        }
    }
}




#Preview("All Data Include") {
    let transaction = Transaction(date: Date(), type: TransactionType.income, amount: 600_000, note: "아빠가 용돈 주심", category: Category(symbol: "💵", name: "용돈", type: TransactionType.income))
    
    NavigationStack {
        TransactionDetail(transaction: transaction)
    }
}

#Preview("Necessary Data only Include") {
    let transaction = Transaction(date: nil, type: TransactionType.expense, amount: 7_000, category: Category(symbol: "🌭", name: "식비", type: TransactionType.expense))
    
    NavigationStack {
        TransactionDetail(transaction: transaction)
    }
}
