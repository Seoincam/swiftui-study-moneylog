//
//  AddTransactionView.swift
//  MoneyLog
//
//  Created by 박서인 on 8/13/25.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var keyboardFocused: Bool
    @State private var showingCategorySelect: Bool = false
    
    let transaction: Transaction
    
    @State private var type: TransactionType
    @State private var amount: Int?
    @State private var category: Category
    @State private var note: String
    
    @State private var enableDate: Bool
    @State private var date: Date

    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        type = transaction.type
        amount = transaction.amount
        enableDate = transaction.date != nil
        date = transaction.date ?? Date.now
        note = transaction.note ?? ""
        category = transaction.category
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("종류", selection: $type) {
                        Text("입금").tag(TransactionType.income)
                        Text("출금").tag(TransactionType.expense)
                    }
                    
                    HStack {
                        plusMinus
                        TextField("금액", value: $amount, format: WonStyleInt())
                            .keyboardType(.numberPad)
                            .focused($keyboardFocused)
                        }
                        .font(.title)
                        .foregroundStyle(color)
                        .toolbar {
                            // FIXME: 간격 문제로 추후 수정해야함.
                            // safeAreaInset 찾아보기
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Check", systemImage: "checkmark") { keyboardFocused = false }
                                    .buttonStyle(.borderedProminent)
                            }
                        }
                }
//                .onChange(of: type) {
//                    category = nil
//                }
                
                Section("세부사항") {
                    NavigationLink {
                        SelectCategoryView(type: type, category: Binding<Category?>($category))
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .padding(4)
                            
                            Text("카테고리")
                                .foregroundStyle(.black)
                            
                            Spacer()

                            Text(category.symbol)
                            Text(category.name)

                            
                        }
                    }
                    
                    HStack {
                        Image(systemName: "text.bubble")
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .padding(4)

                        TextField("설명", text: $note)
                            .focused($keyboardFocused)
                    }
                }
                .listSectionSpacing(.compact)
                
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .padding(4)
                        
                        VStack(alignment: .leading) {
                            Text("날짜")
                            
                            if enableDate {
                                Text(date.formatted(
                                    Date.FormatStyle()
                                        .locale(Locale(identifier: "ko"))
                                        .year()
                                        .month()
                                        .day()
                                        .weekday(.wide)
                                ))
                                .font(.caption)
                                .foregroundStyle(.gray)
                            }
                        }
                        
                        Toggle("", isOn: $enableDate)
                    }
                    
                    if enableDate {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .environment(\.locale, Locale(identifier: "ko"))
                    }
                }
            }
            .animation(.default, value: enableDate)
            
            .toolbar { toolbar }
        }
    }
    
    
    // MARK: - Helper
    
    private var plusMinus: Text {
        type == TransactionType.income ? Text("+") : Text("-")
    }

    
    private var calendarText: String {
        type == TransactionType.income ? "입금일" : "출금일"
    }
    
    private var calendarImage: Image {
        let calendar = Calendar.current
        let day = String(calendar.component(.day, from: date))
        let imageName = day + ".calendar"
        return Image(systemName: imageName)
    }
    
    private var color: Color { type == TransactionType.income ? .red : .blue }
    
    private var canAdd: Bool {
        amount != nil
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
            Text("항목 수정")
                .font(.default)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button("Add or Edit Transaction", systemImage: "checkmark") {
                addEditTransform()
                dismiss()
            }
            .disabled(!canAdd)
            .buttonStyle(.borderedProminent)
        }
    }
    
    
    // MARK: - func
    
    private func addEditTransform() {
        let newDate = enableDate ? date : nil
        let newNote = note == "" ? nil : note
        
        transaction.type = type
        transaction.amount = amount!
        transaction.date = newDate
        transaction.note = newNote
        transaction.category = category
    }
    
}

#Preview {
    EditTransactionView(transaction: Transaction(date: Date.now, type: .expense, amount: 12000, category: Category(symbol: "🎁", name: "사고 싶어요", type: .expense)))
        .modelContainer(PreviewContainer.shared.container)
}
