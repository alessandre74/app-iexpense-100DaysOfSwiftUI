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
                    Section (expenses.sessionTitle(type: type)) {
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

struct ItemsView: View {
    @ObservedObject var expenses: Expenses

    let type: Types

    var loadExpenses: [ExpenseItem] {
        expenses.loadExpenses(filterType: type == .personal ? .personal : .business)
    }
    
    var body: some View {
        ForEach(loadExpenses)  { item  in
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
            expenses.removeItem(indexSet: IndexSet, loadExpenses: loadExpenses)
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
