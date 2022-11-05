//
//  cloudlistApp.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 08/10/2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct cloudlistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appDomainModel = AppDependencyFactory.createDomainModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appDomainModel.networkService.user == nil {
                    AuthView()
                        .environmentObject(appDomainModel.networkService.authService)
                } else {
                    ListView()
                        .environmentObject(appDomainModel.createListViewModel())
                        .environmentObject(appDomainModel.networkService.authService)
                }
            }
            .tint(.theme.cloudBlue)
            .onAppear {
                appDomainModel.networkService.listenToAuthState()
            }
        }
    }
}
