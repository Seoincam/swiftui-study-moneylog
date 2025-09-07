//
//  AddTransactionView.swift
//  MoneyLog
//
//  Created by 박서인 on 8/13/25.
//

import SwiftUI
import SwiftData

struct AddEditTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var keyboardFocused: Bool
    @State private var showingCategorySelect: Bool = false
    
    let isAdding: Bool
    let transaction: Transaction?
    
    @State private var type: TransactionType
    @State private var amount: Int?
    @State private var category: Category?
    @State private var note: String
    
    @State private var enableDate: Bool
    @State private var date: Date
    
    
    init() {
        isAdding = true
        transaction = nil
        
        type = TransactionType.income
        amount = nil
        enableDate = true
        date = Date.now
        note = ""
        category = nil
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
                .onChange(of: type) {
                    category = nil
                }
                
                Section("세부사항") {
                    NavigationLink {
                        SelectCategoryView(type: type, category: $category)
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .padding(4)
                            
                            Text("카테고리")
                                .foregroundStyle(.black)
                            
                            Spacer()

                            if let category = category {
                                Text(category.symbol)
                                Text(category.name)
                            } else {
                                Text("미선택")
                                    .foregroundStyle(.gray)
                            }
                            
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
        && category != nil
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
            Text("항목 추가")
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
        
        if isAdding {
            let transaction = Transaction(date: newDate, type: type, amount: amount!, note: newNote, category: category!)
            modelContext.insert(transaction)
        } else {
            transaction!.type = type
            transaction!.amount = amount!
            transaction!.date = newDate
            transaction!.note = newNote
            transaction!.category = category!
        }
    }
    
}

#Preview {
    AddEditTransactionView()
}
