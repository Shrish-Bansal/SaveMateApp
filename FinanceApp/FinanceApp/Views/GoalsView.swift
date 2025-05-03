//
//  GoalsView.swift
//  FinanceApp
//
//  Created by Shrish Bansal on 2025/04/10.
//

import SwiftUI

struct GoalsView: View {
    @State private var showSheet: Bool = false
    @EnvironmentObject var userDataModel: UserDataModel
    @State var goalName: String = ""
    @State var amountGoal: Double = 0
    @State var showAlert: Bool = false
    var totalSavings: Double {
        return userDataModel.Expenses.reduce(into: 0.0) { result, expense in
            if expense.expenseType == .savings {
                result += expense.amount
            }
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
                        Text("Add Goal")
                            .foregroundStyle(Color("Texts"))
                            .padding()
                            .background(Color("Images").clipShape(RoundedRectangle(cornerRadius: 10)))
                    })
                    .sheet(isPresented: $showSheet, content: {
                        AddGoal
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Text("Current Goals:")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                Spacer()
                List {
                    ForEach(userDataModel.Goals, id: \.id) { goal in
                        VStack {
                            HStack {
                                Text(goal.name)
                                Spacer()
                                Text("\(userDataModel.currencyChosen)\(String(format: "%.2f", goal.amount))")
                            }
                            
                            ProgressView(
                                value: totalSavings,
                                total: goal.amount
                            )
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: deleteGoal)
                    .padding()
                }

            }
        }
    }
    func deleteGoal(at offsets: IndexSet) {
        userDataModel.Goals.remove(atOffsets: offsets)
    }
    func calcPerc(amount: Double) -> Double {
        let perc: Double = ((totalSavings / amount) * 100)
        print(totalSavings)
        print(amount)
        print(perc)
        return perc <= 100 ? perc : 100
    }
}

#Preview {
    GoalsView()
}
extension GoalsView {
    var AddGoal: some View {
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
                
                Text("Goal Name")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                TextField("Enter the name of the goal...", text: $goalName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                Text("Goal amount")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                TextField("Enter required savings value...", value: $amountGoal, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button {
                    let newGoal = Goal(name: goalName, amount: amountGoal)
                    if amountGoal == 0 || goalName.isEmpty {
                        showAlert.toggle()
                    }
                    else {
                        userDataModel.Goals.append(newGoal)
                        amountGoal = 0
                        goalName = ""
                    }

                } label: {
                    Text("Save")
                        .foregroundStyle(Color("Texts"))
                        .padding()
                        .background(Color("Images").clipShape(RoundedRectangle(cornerRadius: 10)))
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Invalid Value!"),
                          message: Text("You've left one or more fields blank!"),
                          dismissButton: .default(Text("Try Again")))
                })
                Spacer()
            }
            .onTapGesture { hideKeyboard() }
        }
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
