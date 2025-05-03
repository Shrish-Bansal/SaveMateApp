//
//  TransactionView.swift
//  FinanceApp
//
//  Created by Shrish Bansal on 2025/02/01.
//

import SwiftUI

struct TransactionView: View {
    @EnvironmentObject var userDataModel: UserDataModel
    @State private var showSheet: Bool = false
    @State private var amountTransaction: Double = 0
    @State private var detailsTransaction: String = ""
    @State private var showAlert: Bool = false
    @State private var typeTransaction: TransactionTypes = .income
    @State private var typeExpense: ExpenseTypes = .needs
    @State var totalEx = 0.0
    @State var totalIn = 0.0

    var totalExpenses: Double {
        userDataModel.Expenses.reduce(0) { result, transaction in
            result + (transaction.type == .expense ? transaction.amount : -transaction.amount)
        }
    }

    var body: some View {
        ZStack {
            Color("MainBackground").edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text("Add Transaction")
                            .foregroundStyle(Color("Texts"))
                            .padding()
                            .background(Color("Images").clipShape(RoundedRectangle(cornerRadius: 10)))
                    })
                    .sheet(isPresented: $showSheet, content: {
                        AddTransaction
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Text("Recent transactions:")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                List {
                    ForEach(userDataModel.Expenses, id: \.id) { expense in
                        HStack {
                            Text(expense.details)
                            Spacer()
                            Text(expense.type == .income ? "+" : "-")
                                .foregroundColor(expense.type == .income ? .green : .red)
                            Text("\(userDataModel.currencyChosen)\(String(format: "%.2f", expense.amount))")
                                .foregroundColor(expense.type == .income ? .green : .red)
                        }
                    }
                    .onDelete(perform: deleteTransaction)
                    .padding()
                }

                Text("Total Expenses: \(userDataModel.currencyChosen)\(String(format: "%.2f", totalExpenses))")
                    .font(.headline)
                    .foregroundColor(totalExpenses > userDataModel.income ? .red : Color("Texts"))
                    .padding()
                
                Spacer()
            }
        }
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        userDataModel.Expenses.remove(atOffsets: offsets)
        totalEx = userDataModel.Expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        totalIn = userDataModel.income + userDataModel.Expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
}

#Preview {
    ZStack {
        Color("MainBackground").edgesIgnoringSafeArea(.all)
        TransactionView()
            .environmentObject(UserDataModel())
    }
}

extension TransactionView {
    var AddTransaction: some View {
        ZStack {
            Color("MainBackground").edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        showSheet = false
                    }, label: {
                        Text("X")
                            .padding()
                            .background(Color.white.clipShape(Circle()))
                    })
                    Spacer()
                }
                
                Text("Amount")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                TextField("Enter transaction value...", value: $amountTransaction, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Transaction details")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                TextField("Enter transaction details...", text: $detailsTransaction)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Transaction type")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                Picker("", selection: $typeTransaction) {
                    Text("Income").tag(TransactionTypes.income)
                    Text("Expense").tag(TransactionTypes.expense)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if (typeTransaction == .expense){
                    Picker("", selection: $typeExpense) {
                        Text("Needs").tag(ExpenseTypes.needs)
                        Text("Wants").tag(ExpenseTypes.wants)
                        Text("Savings").tag(ExpenseTypes.savings)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                Button {
                    let needsLimit = (userDataModel.needs / 100) * userDataModel.spendLimit
                    let savingsLimit = (userDataModel.savings / 100) * userDataModel.spendLimit
                    let wantsLimit = (userDataModel.wants / 100) * userDataModel.spendLimit

                    if amountTransaction == 0 || detailsTransaction.isEmpty {
                        showAlert.toggle()
                    } else {
                        let newTransaction = Transaction(amount: amountTransaction, details: detailsTransaction, type: typeTransaction, expenseType: typeTransaction == .expense ? typeExpense : nil)

                        totalEx = userDataModel.Expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
                        totalIn = userDataModel.income + userDataModel.Expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }

                        let spentOnNeeds = userDataModel.Expenses.filter { $0.expenseType == .needs }.reduce(0) { $0 + $1.amount }
                        let spentOnWants = userDataModel.Expenses.filter { $0.expenseType == .wants }.reduce(0) { $0 + $1.amount }
                        let spentOnSavings = userDataModel.Expenses.filter { $0.expenseType == .savings }.reduce(0) { $0 + $1.amount }

                        if totalEx > totalIn || spentOnNeeds > needsLimit || spentOnWants > wantsLimit || spentOnSavings > savingsLimit {
                            showAlert = true
                        }
                        else {
                            userDataModel.Expenses.append(newTransaction)
                            amountTransaction = 0
                            detailsTransaction = ""
                            typeTransaction = .income
                        }
                    }
                } label: {
                    Text("Save")
                        .foregroundStyle(Color("Texts"))
                        .padding()
                        .background(Color("Images").clipShape(RoundedRectangle(cornerRadius: 10)))
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Invalid Value!"),
                          message: Text("Your expenses are higher than your income! Try to cut back on non-essential spending! OR You've left one or more fields blank!"),
                          dismissButton: .default(Text("Try Again")))
                })

                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Invalid Value!"),
                          message: Text("Your expenses are higher than your income! Try to cut back on non-essential spending! OR You've left one or more fields blank!"),
                          dismissButton: .default(Text("Try Again")))
                })
                Spacer()
            }
            .onTapGesture { hideKeyboard() }
            .padding()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
