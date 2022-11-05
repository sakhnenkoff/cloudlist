//
//  AuthenticationModel.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 04/11/2022.
//

import SwiftUI
import FirebaseAuth

final class AuthenticationModel: ObservableObject {
  var user: User? {
    didSet {
      objectWillChange.send()
    }
  }

  func listenToAuthState() {}

  func signUp(
    emailAddress: String,
    password: String
  ) {}

  func signIn(
    emailAddress: String,
    password: String
  ) {}

  func signOut() {}
}

