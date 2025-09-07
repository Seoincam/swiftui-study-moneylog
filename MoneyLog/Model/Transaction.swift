//
//  Transaction.swift
//  MoneyLog
//
//  Created by 박서인 on 8/13/25.
//

import Foundation
import SwiftData


@Model
final class Transaction {
    var date: Date?
    var type: TransactionType
    var amount: Int
    var note: String?
    
    var category: Category
    var createdAt: Date
    
    init(date: Date?,
         type:TransactionType,
         amount: Int,
         note: String? = nil,
         category: Category,
         createdAt: Date = Date.now) {
        self.date = date
        self.type = type
        self.amount = amount
        self.note = note
        self.category = category
        self.createdAt = createdAt
    }
}

enum TransactionType: String, Codable {
    case income = "income"
    case expense = "expense"
}
