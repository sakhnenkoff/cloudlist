//
//  AuthenticationService.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 04/11/2022.
//

import SwiftUI
import FirebaseAuth

final class AuthenticationService: ObservableObject {
    weak var networkService: NetworkService?

    var user: User? {
        didSet {
            networkService?.user = user
        }
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
          guard let self = self else {
            return
          }
          self.user = user
        }
    }
    
    func signUp(
        emailAddress: String,
        password: String
    ) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
        }
    }
    
    func signIn(
        emailAddress: String,
        password: String
    ) {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}

