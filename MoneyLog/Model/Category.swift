//
//  Category.swift
//  MoneyLog
//
//  Created by 박서인 on 8/14/25.
//

import Foundation
import SwiftData

@Model
final class Category {
    var symbol: String
    var name: String
    var type: TransactionType
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.category)
    var transactions: [Transaction] = []
    
    init(symbol: String, name: String, type: TransactionType) {
        self.symbol = symbol
        self.name = name
        self.type = type
    }
}
