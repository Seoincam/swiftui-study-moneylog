//
//  TransactionSummaryView.swift
//  MoneyLog
//
//  Created by 박서인 on 8/13/25.
//

import SwiftUI
import SwiftData

struct TransactionSummaryView: View {
    @Query private var transactions: [Transaction]
    
    @Query private var categories: [Category]
    private var incomeCategories: [Category] {
        categories.filter { $0.type == .income }
    }
    private var expenseCategories: [Category] {
        categories.filter { $0.type == .expense }
    }
    
    @State private var showingIncomeCategories = false
    @State private var showingExpenseCategories = false
    
    var body: some View {
        Form {
            Section("총괄") {
                HStack {
                    Image(systemName: "wallet.bifold")
                        .foregroundStyle(.gray)
                    Text("잔액")
                    Spacer()
                    Text("\(total, format: WonStyleInt())")
                        .foregroundStyle(color(amount: total))
                }
                .font(.title3)
            }
            .headerProminence(.increased)
            
            Section {
                Button {
                    withAnimation(.default) {
                        showingIncomeCategories.toggle()
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: "banknote")
                            .foregroundStyle(.gray)
                        Text("수익 총괄")
                        Spacer()
                        Text("+\(incomeTotal, format: WonStyleInt())")
                            .foregroundStyle(.red)
                    }
                    .font(.callout)
                    .foregroundStyle(.foreground)
                }
                
                if (showingIncomeCategories) {
                    ForEach(incomeCategories) { c in
                        HStack {
                            Text(c.symbol)
                            Text(c.name)
                            Spacer()
                            Text("+\(c.transactions.reduce(0) { $0 + $1.amount }, format: WonStyleInt())")
                        }
                        .foregroundStyle(.gray)
                    }
                }
            }
            
            Section {
                Button {
                    withAnimation(.default) {
                        showingExpenseCategories.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "creditcard")
                            .foregroundStyle(.gray)
                        Text("지출 총괄")
                        Spacer()
                        Text("-\(expenseTotal, format: WonStyleInt())")
                            .foregroundStyle(.blue)
                    }
                    .font(.callout)
                    .foregroundStyle(.foreground)
                }
                
                if (showingExpenseCategories) {
                    ForEach(expenseCategories) { c in
                        HStack {
                            Text(c.symbol)
                            Text(c.name)
                            Spacer()
                            Text("-\(c.transactions.reduce(0) { $0 + $1.amount }, format: WonStyleInt())")
                        }
                        .foregroundStyle(.gray)
                    }
                }
            }
            .listSectionSpacing(.compact)
        }
    }
    
    private var total: Int {
        transactions.reduce(0) { $0 + ($1.type == TransactionType.income ? $1.amount : $1.amount * -1) }
    }
    
    private var incomeTotal: Int {
        transactions.filter { $0.type == TransactionType.income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var expenseTotal: Int {
        transactions.filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private func color(amount: Int) -> Color {
        amount >= 0 ? .red : .blue
    }
}

#Preview {
    TransactionSummaryView()
        .modelContainer(PreviewContainer.shared.container)
}
