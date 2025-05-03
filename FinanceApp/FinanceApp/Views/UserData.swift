import SwiftUI

class UserDataModel: ObservableObject {
    @Published var userData: [dataVariableModel] = [] {
        didSet {
            saveItems()
        }
    }

    // Access the first user in the array as the "current" user
    var currentUser: dataVariableModel {
        get {
            userData.first ?? dataVariableModel() // Default to a blank user
        }
        set {
            if userData.isEmpty {
                userData.append(newValue)
            } else {
                userData[0] = newValue
            }
            saveItems()
        }
    }

    // Convenience accessors for properties
    var userName: String {
        get { currentUser.userName }
        set {
            var user = currentUser
            user.userName = newValue
            currentUser = user
        }
    }

    var password: String {
        get { currentUser.password }
        set {
            var user = currentUser
            user.password = newValue
            currentUser = user
        }
    }

    var income: Double {
        get { currentUser.income }
        set {
            var user = currentUser
            user.income = newValue
            currentUser = user
        }
    }

    var currencyChosen: String {
        get { currentUser.currencyChosen }
        set {
            var user = currentUser
            user.currencyChosen = newValue
            currentUser = user
        }
    }

    var spendLimit: Double {
        get { currentUser.spendLimit }
        set {
            var user = currentUser
            user.spendLimit = newValue
            currentUser = user
        }
    }

    var needs: Double {
        get { currentUser.needs }
        set {
            var user = currentUser
            user.needs = newValue
            currentUser = user
        }
    }

    var wants: Double {
        get { currentUser.wants }
        set {
            var user = currentUser
            user.wants = newValue
            currentUser = user
        }
    }

    var savings: Double {
        get { currentUser.savings }
        set {
            var user = currentUser
            user.savings = newValue
            currentUser = user
        }
    }

    var signInStatus: Bool {
        get { currentUser.signInStatus }
        set {
            var user = currentUser
            user.signInStatus = newValue
            currentUser = user
        }
    }

    var Expenses: [Transaction] {
        get { currentUser.Expenses }
        set {
            var user = currentUser
            user.Expenses = newValue
            currentUser = user
        }
    }
    
    var Bills: [Transaction] {
        get { currentUser.Expenses }
        set {
            var user = currentUser
            user.Expenses = newValue
            currentUser = user
        }
    }
    
    var needsBudget: Double {
        return (needs / 100) * spendLimit
    }
    var wantsBudget: Double {
        return (wants / 100) * spendLimit
    }
    var savingsBudget: Double {
        return (savings / 100) * spendLimit
    }
    var Goals: [Goal] {
        get {
            currentUser.Goals
        }
        set {
            var user = currentUser
            user.Goals = newValue
            currentUser = user
        }
    }

    // Data persistence
    init() {
        loadItems()
    }

    private let dataKey: String = "user_data"

    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encodedData, forKey: dataKey)
        }
    }

    private func loadItems() {
        guard
            let savedData = UserDefaults.standard.data(forKey: dataKey),
            let decodedItems = try? JSONDecoder().decode([dataVariableModel].self, from: savedData)
        else {
            return
        }
        self.userData = decodedItems
    }
}

struct dataVariableModel: Codable {
    var userName: String = ""
    var password: String = ""
    var income: Double = 0.0
    var currencyChosen: String = ""
    var spendLimit: Double = 0
    var needs: Double = 0
    var wants: Double = 0
    var savings: Double = 0
    var signInStatus: Bool = false
    var Expenses: [Transaction] = []
    var Bills: [Transaction] = []
    var Goals: [Goal] = []
}

struct Transaction: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var amount: Double
    var details: String
    var type: TransactionTypes
    var expenseType: ExpenseTypes?
    var dueDate: Date?

    init(amount: Double, details: String, type: TransactionTypes, expenseType: ExpenseTypes? = nil, dueDate: Date? = nil) {
        self.amount = amount
        self.details = details
        self.type = type
        self.expenseType = (type == .expense) ? expenseType : nil
        self.dueDate = dueDate
    }
}


enum TransactionTypes: Codable {
    case income
    case expense
    case sub
}

enum ExpenseTypes: Codable {
    case needs
    case wants
    case savings
}

struct Goal: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var amount: Double
}
