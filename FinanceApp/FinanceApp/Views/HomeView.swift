//
//  HomeView.swift
//  FinanceApp
//
//  Created by Shrish Bansal on 2025/01/11.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userDataModel: UserDataModel
    
    var body: some View {
        Group {
            if !userDataModel.signInStatus {
                SignInView()
            } else {
                Tabs
            }
        }
        .onAppear {
            requestNotificationPermission()
        }
    }

    func requestNotificationPermission() {
        let notificationPermissionGranted = UserDefaults.standard.bool(forKey: "NotificationPermissionGranted")
        
        if !notificationPermissionGranted {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    print("Permission granted")
                    UserDefaults.standard.set(true, forKey: "NotificationPermissionGranted")
                } else {
                    print("Permission denied: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserDataModel())
}

extension HomeView {
    var Tabs: some View {
        TabView {
            HomeScreenView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            TransactionView()
                .tabItem {
                    Label("Transactions", systemImage: "dollarsign.circle.fill")
                }
            BillsView()
                .tabItem {
                    Label("Bills", systemImage: "doc.text.fill")
                }
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "flag.checkered")
                }
        }
    }
}
