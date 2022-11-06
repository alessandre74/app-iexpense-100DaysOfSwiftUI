//
//  AddView.swift
//  iExpense
//
//  Created by Alessandre Livramento on 20/10/22.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = Types.personal
    @State private var amount = 0.0
    @State private var currency = Currency.usd
    
    @FocusState var selectedName: Bool

    @ObservedObject var expenses: Expenses

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .focused($selectedName)

                Picker("Type", selection: $type) {
                    ForEach(Types.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }

                Section("currency") {
                    Picker("Currency", selection: $currency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                TextField("Amount", value: $amount, format: .currency(code: currency.rawValue))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type.rawValue, amount: amount, currency: currency.rawValue)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
        .onAppear {
            selectedName = true
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
