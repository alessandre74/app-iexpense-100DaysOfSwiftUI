//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Alessandre Livramento on 20/10/22.
//

import Foundation


enum Types: String, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}

enum Currency: String, CaseIterable {
    case usd = "USD"
    case eur = "EUR"
    case brl = "BRL"
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
}




