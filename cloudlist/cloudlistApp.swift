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
    private let appDomainModel = AppFactory.createDomainModel()
    private var authModel: AuthenticationModel {
        appDomainModel.createAuthModel()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Group {
                    ListView()
                }
            }
            .tint(.theme.cloudBlue)
            .environmentObject(appDomainModel.createListViewModel())
            .environmentObject(authModel)
        }
    }
}
