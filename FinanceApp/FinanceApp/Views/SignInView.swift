//
//  SignInView.swift
//  FinanceApp
//
//  Created by Shrish Bansal on 2025/01/11.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userDataModel: UserDataModel
    @State var fixedExpenseName: String = ""
    @State var fixedExpenseValue: Double = 0
    @State var showAlert: Bool = false
    @State var Stage: Int = 0
    
    var body: some View {
        switch(Stage) {
        case 0:
            welcomeView
        case 1:
            nameView
        case 2:
            incomeView
        case 3:
            spendLimitView
        case 4:
            expendSplitView
        case 5:
            expensesView
        case 6:
            wellDoneText
        default:
            welcomeView
        }
    }
    
    func getAlert(text: String) -> Alert {
        return Alert(title: Text(text), dismissButton: .default(Text("Ok")))
    }
}

#Preview {
    @StateObject @Previewable var userDataModel: UserDataModel = UserDataModel()
    ZStack {
        Color(#colorLiteral(red: 0.3483397365, green: 0.9218218537, blue: 0.3742293793, alpha: 1)).ignoresSafeArea(.all) //59CC62
        SignInView()
            .environmentObject(userDataModel)
    }

}

extension SignInView {
    
    private var welcomeView: some View {
        VStack {
            Spacer()
            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                .padding()
                .shadow(radius: 10)
            Text("Welcome to the MoneyMate App,\nthe best way to manage your finances!\nClick Sign-In to get started!")
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                Stage += 1
            },
                   label: {
                Text("Sign-in")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            Spacer()
            Spacer()
        }
    }
    
    private var nameView: some View {
        VStack{
            Spacer()
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                .padding()
                .shadow(radius: 10)
            Text("To get started, enter your username and password: ")
                .multilineTextAlignment(.center)
                .padding()
            Text("Username: ")
                .padding()
            TextField("Enter your username...", text: $userDataModel.userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Password: ")
                .padding()
            TextField("Enter your password...", text: $userDataModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                guard !userDataModel.userName.isEmpty, !userDataModel.password.isEmpty else
                {
                    showAlert.toggle()
                    return
                }
                Stage += 1
            },
                   label: {
                Text("Next")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            .alert(isPresented: $showAlert, content: {
                getAlert(text: "You have entered an invalid value. Username and password cannot be empty. Please try again!")
            })
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var incomeView: some View {
        VStack{
            Spacer()
            Image(systemName: "banknote.fill")
                .resizable()
                .frame(width: 250, height: 150)
                .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                .padding()
                .shadow(radius: 10)
            
            Text("What is your income?")
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Enter your monthly income: ")
                .padding()
            
            let currency: [String] = ["$", "€", "£", "¥", "₣", "₹", "A$", "C$", "R$", "₱", "R", "S$", "HK$"]
            
            
            TextField("Enter your income...", value: $userDataModel.income, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Text("Choose your currency: ")
                    .font(.headline)
                Picker(
                    selection: $userDataModel.currencyChosen,
                    content: {
                        ForEach(currency, id: \.self) { symbol in
                            Text(symbol).tag(symbol)
                        }
                    },
                    label: { Text("") }
                )
                .padding()
                
            }
            
            Text("Income: \(userDataModel.currencyChosen) \(userDataModel.income, specifier: "%.2f")")
                .padding()

            Button(action: {
                guard userDataModel.income != 0, !userDataModel.currencyChosen.isEmpty else {
                    showAlert.toggle()
                    return
                }
                Stage += 1
            },
                   label: {
                Text("Next")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            .alert(isPresented: $showAlert, content: {
                getAlert(text: "You have entered an invalid value for income or currency. Please try again!")
            })
            Spacer()
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var spendLimitView: some View {
        VStack {
            Spacer()
            ZStack {
                Image(systemName: "banknote.fill")
                    .resizable()
                    .frame(width: 250, height: 150)
                    .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                    .padding()
                    .shadow(radius: 10)
                Image(systemName: "lock.fill")
                    .resizable()
                    .frame(width: 120, height: 200)
                    .foregroundStyle(Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
                    .padding()
            }
            
            Text("Please enter your ideal maximum MONTHLY spending limit:")
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Enter your MONTHLY spend limit...", value: $userDataModel.spendLimit, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Monthly Spend Limit: \(userDataModel.currencyChosen) \(userDataModel.spendLimit, specifier: "%.2f")")
                .padding()

            Button(action: {
                guard userDataModel.spendLimit != 0, userDataModel.spendLimit <= userDataModel.income else {
                    showAlert.toggle()
                    return
                }
                Stage += 1
            },
                   label: {
                Text("Next")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            .alert(isPresented: $showAlert, content: {
                getAlert(text: "You have entered an invalid value for spend limit. Please try again!")
            })
            Spacer()
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var expendSplitView: some View {
        VStack {
            Spacer()
            
            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                .padding()
                .shadow(radius: 10)
            
            Text("Percentage of expenditure allocated to needs monthly")
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Enter the percentage allocated to needs...", value: $userDataModel.needs, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Percentage of expenditure allocated to wants monthly")
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Enter the percentage allocated to wants...", value: $userDataModel.wants, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Percentage of expenditure allocated to savings monthly")
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Enter the percentage allocated to savings...", value: $userDataModel.savings, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Tip! The best split percentages are 50/30/20, but you may choose any split percentage according to your needs!")
                .multilineTextAlignment(.center)
                .padding()
                .bold()
                .font(.caption)
            
            Button(action: {
                guard userDataModel.needs+userDataModel.wants+userDataModel.savings == 100 else {
                    showAlert.toggle()
                    return
                }
                Stage += 1
            },
                   label: {
                Text("Next")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            .alert(isPresented: $showAlert, content: {
                getAlert(text: "You have entered an invalid value. Please try again!")
            })

            
            Spacer()
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var expensesView: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "banknote.fill")
                    .resizable()
                    .frame(width: 250, height: 150)
                    .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                    .padding()
                    .shadow(radius: 10)
                Image(systemName: "arrow.down")
                    .resizable()
                    .frame(width: 120, height: 200)
                    .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                    .padding()
            }
            Text("Enter your fixed monthly expenses (Also include any active subscriptions): ")
                .multilineTextAlignment(.center)
                .padding()
            
            // Input fields for expense name and value
            HStack {
                TextField("Enter expense name...", text: $fixedExpenseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Enter expense value...", value: $fixedExpenseValue, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            // Button to add a new fixed expense
            Button(action: {
                guard !fixedExpenseName.isEmpty, fixedExpenseValue > 0 else {
                    showAlert.toggle()
                    return
                }
                let newTransaction = Transaction(amount: fixedExpenseValue, details: fixedExpenseName, type: .expense)
                userDataModel.Expenses.append(newTransaction)
                fixedExpenseName = ""
                fixedExpenseValue = 0
            },
                   label: {
                Text("Save Expense")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            .alert(isPresented: $showAlert, content: {
                getAlert(text: "You have entered an invalid value. Please try again!")
            })
            
            List(userDataModel.currentUser.Expenses, id: \.amount) { transaction in
                HStack {
                    Text(transaction.details)
                    Spacer()
                    Text("\(transaction.amount, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            
            Button(action: {
                Stage += 1
            },
                   label: {
                Text("Next")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            
            Spacer()
            Spacer()
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var wellDoneText: some View {
        VStack {
            Spacer()
            
            Image(systemName: "checkmark.square.fill")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)))
                .padding()
                .shadow(radius: 10)
            Text("Congratulations! Sign-up successful!")
            Button(action: {
                userDataModel.signInStatus = true
                Stage += 1
            },
                   label: {
                Text("Finish")
                    .foregroundStyle(Color(#colorLiteral(red: 0.3483397365, green: 0.7989274263, blue: 0.3861996531, alpha: 1)))
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .shadow(radius: 15)
            })
            Spacer()
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
