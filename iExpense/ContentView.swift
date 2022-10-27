//
//  ContentView.swift
//  iExpense
//
//  Created by Alessandre Livramento on 18/10/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            List {
                ForEach(Types.allCases, id: \.self) { type in
                    Section (sessionTitle(type: type, expenses: expenses)) {
                        ItemsView(expenses: expenses, type: type)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }

}

func sessionTitle (type: Types, expenses: Expenses) -> String {
    let title = type.rawValue

    let typePersonal = Types.personal.rawValue
    let typeBusiness = Types.business.rawValue

    let personalExpenses = expenses.loadExpenses(filterType: .personal)
    let businessExpensens = expenses.loadExpenses(filterType: .business)

    return title == typePersonal && personalExpenses.isEmpty || title == typeBusiness && businessExpensens.isEmpty ? "" : title
}

struct ItemsView: View {
    @ObservedObject var expenses: Expenses

    let type: Types

    var personalExpenses: [ExpenseItem] {
        expenses.loadExpenses(filterType: .personal)
    }

    var businessExpenses:[ExpenseItem] {
        expenses.loadExpenses(filterType: .business)
    }

    var body: some View {
        ForEach( type == .personal ? personalExpenses : businessExpenses)  { item  in
            HStack {
                VStack (alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.type)
                }

                Spacer()
                Text(item.amount, format: .currency(code: item.currency))
                    .amountStyles(amount: item.amount)
            }
        }
        .onDelete { IndexSet in
            var idUUID = [UUID]()

            for index in IndexSet {
                idUUID.append(type == .personal ? personalExpenses[index].id : businessExpenses[index].id)
            }

            if let itemIndex = expenses.items.firstIndex(where: {$0.id == idUUID[0] }) {
                expenses.items.remove(at: itemIndex)
            }
        }
    }
}

struct Amount: ViewModifier {
    var amount: Double

    func body(content: Content) -> some View {

        if amount <= 10 {
            content
                .foregroundColor(.blue)
        }

        if amount > 10 && amount <= 100 {
            content
                .foregroundColor(.purple)
        }

        if amount > 100 {
            content
                .foregroundColor(.green)
        }
    }
}

extension View {
    func amountStyles (amount: Double) -> some View {
        modifier(Amount(amount: amount))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
