import SwiftUI
import UserNotifications

struct BillsView: View {
    @EnvironmentObject var userDataModel: UserDataModel
    @State private var showSheet: Bool = false
    @State private var amountBill: Double = 0
    @State private var detailsBill: String = ""
    @State private var showAlert: Bool = false
    @State private var dueDate: Date = Date()

    var totalExpenses: Double {
        userDataModel.Expenses.filter { $0.type == .sub }.reduce(0) { result, transaction in
            result + transaction.amount
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
                        Text("Add Bill")
                            .foregroundStyle(Color("Texts"))
                            .padding()
                            .background(Color("Images").clipShape(RoundedRectangle(cornerRadius: 10)))
                    })
                    .sheet(isPresented: $showSheet, content: {
                        AddSubscription
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Text("Pending bills:")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                List {
                    ForEach(userDataModel.Expenses.filter { $0.type == .sub }, id: \.id) { sub in
                        HStack {
                            Text(sub.details)
                            Spacer()
                            Text("\(userDataModel.currencyChosen)\(String(format: "%.2f", sub.amount))")
                                .foregroundColor(.red)
                        }
                    }
                    .onDelete(perform: deleteSubscription)
                    .padding()
                }

                Text("Total Cost: \(userDataModel.currencyChosen)\(String(format: "%.2f", totalExpenses))")
                    .font(.headline)
                    .foregroundColor(totalExpenses > userDataModel.income ? .red : Color("Texts"))
                    .padding()
                
                Spacer()
            }
        }
    }
    
    func deleteSubscription(at offsets: IndexSet) {
        userDataModel.Expenses.remove(atOffsets: offsets)
        userDataModel.Bills.remove(atOffsets: offsets)
    }
    
    func scheduleBillNotification(for bill: Transaction) {
        let content = UNMutableNotificationContent()
        content.title = "Bill Due: \(bill.details)"
        content.body = "Your bill of \(userDataModel.currencyChosen)\(String(format: "%.2f", bill.amount)) is due today."
        content.sound = .default
        guard let dD = bill.dueDate else { return }
        // Set the trigger for the notification at the due date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day], from: dD), repeats: false)

        // Create the notification request
        let request = UNNotificationRequest(identifier: bill.id.uuidString, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(dD)")
            }
        }
    }

}

extension BillsView {
    var AddSubscription: some View {
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
                
                TextField("Enter bill value...", value: $amountBill, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Bill details")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                TextField("Enter bill details...", text: $detailsBill)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Bill due date")
                    .foregroundStyle(Color("Texts"))
                    .font(.title)
                    .bold()
                
                DatePicker(
                    "Date"
                    , selection: $dueDate,
                    displayedComponents: .date)
                
                Button {
                    let newBill = Transaction(amount: amountBill, details: detailsBill, type: .sub, dueDate: dueDate)
                    if amountBill == 0 || detailsBill.isEmpty {
                        showAlert.toggle()
                    }
                    else {
                        userDataModel.Bills.append(newBill)
                        scheduleBillNotification(for: newBill)
                        amountBill = 0
                        detailsBill = ""
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
            .padding()
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
