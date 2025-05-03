//
//  FinanceAppApp.swift
//  FinanceApp
//
//  Created by Shrish Bansal on 2025/01/11.
//

import SwiftUI

@main
struct FinanceAppApp: App {
    @State private var showLaunchScreen = true
    @StateObject var userDataModel: UserDataModel = UserDataModel()
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showLaunchScreen = false
                        }
                    }
            }
            else {
                ZStack {
                    Color("MainBackground").edgesIgnoringSafeArea(.all)
                    HomeView()
                        .environmentObject(userDataModel)
                }
            }
        }
    }
}
