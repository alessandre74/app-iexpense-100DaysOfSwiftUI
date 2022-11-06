//
//  Expenses.swift
//  iExpense
//
//  Created by Alessandre Livramento on 22/10/22.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let saveItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodeItems = try? JSONDecoder().decode([ExpenseItem].self, from: saveItems) {
                items = decodeItems
                return
            }
        }

        items = []
    }

    func loadExpenses(filterType: Types) -> [ExpenseItem] {
        items.filter { $0.type == filterType.rawValue }
    }
    
    func sessionTitle (type: Types) -> String {
        return loadExpenses(filterType: type == .personal ? .personal : .business).isEmpty ? "": type.rawValue
    }
    
    func removeItem(indexSet: IndexSet, loadExpenses: [ExpenseItem]) {
        var idUUID = [UUID]()

        for index in indexSet {
            idUUID.append(loadExpenses[index].id)
        }

        if let itemIndex = items.firstIndex(where: {$0.id == idUUID[0] }) {
            items.remove(at: itemIndex)
        }
    }
}
