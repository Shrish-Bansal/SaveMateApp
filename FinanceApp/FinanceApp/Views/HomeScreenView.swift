//
//  HomeScreenView.swift
//  FinanceApp
//
//  Created by Shrish Bansal on 2025/02/01.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var userDataModel: UserDataModel
    @State var expenses: [Double] = []
    @State var moneyRemaining: Double = 0
    @State var showSheet: Bool = false
    @State var showTipSheet: Bool = false
    var body: some View {
        ZStack {
            Color("MainBackground").edgesIgnoringSafeArea(.all)
            
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .padding()
                    .foregroundStyle(Color("Images"))
                    .overlay(content: {
                        VStack{
                            Image(systemName: "banknote.fill")
                                .resizable()
                                .frame(width: 150, height: 100)
                            Text("Income Remaining:")
                                .font(.caption)
                                .padding(.vertical)
                            
                            Text("\(userDataModel.currencyChosen)\(String(format: "%.2f", moneyRemaining))")
                        }
                        .foregroundStyle(Color("Texts"))
                    })
                Text("Recent Transactions:")
                    .foregroundStyle(Color("Texts"))
                    .font(.title2)
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .padding(.vertical, -10)
                    .foregroundStyle(Color("Images"))
                    .overlay(content: {
                        VStack{
                            List() {
                                ForEach(userDataModel.Expenses, id: \.id) { expense in
                                    HStack {
                                        Text(expense.details)
                                        Spacer()
                                        Text(expense.type == .income ? "+" : "-")
                                            .foregroundColor(expense.type == .income ? .green : .red)
                                        Text("\(userDataModel.currencyChosen)" + "\(String(format: "%.2f", expense.amount))")
                                            .foregroundColor(expense.type == .income ? .green : .red)
                                    }
                                }
                                .padding()
                            }
                        }
                        .onTapGesture {
                            showSheet.toggle()
                        }
                        .sheet(isPresented: $showSheet) {
                            TransactionView()
                        }
                    })
                
                Spacer()
                Button{
                    showTipSheet.toggle()
                } label: {
                    Text("Get a random tip!")
                        .padding()
                        .background(Color.green.clipShape(RoundedRectangle(cornerRadius: 10)))
                        .foregroundStyle(Color.white)
                }
                .sheet(isPresented: $showTipSheet, content: {
                    LaunchScreenView()
                })
            }
        }
        .onAppear(perform: {
            let totalIncome = userDataModel.Expenses.filter { $0.type == .income }.map { $0.amount }.reduce(0, +)
            let totalExpenses = userDataModel.Expenses.filter { $0.type == .expense }.map { $0.amount }.reduce(0, +)
            moneyRemaining = userDataModel.income + totalIncome - totalExpenses
        })
    }
}

#Preview {
    HomeScreenView()
        .environmentObject(UserDataModel())
}
