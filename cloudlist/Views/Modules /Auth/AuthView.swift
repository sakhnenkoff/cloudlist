//
//  AuthView.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 05/11/2022.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authModel: AuthenticationService
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var isJournalShown = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.lavenderGray
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 40) {
                Spacer()
                
                header()
                inputFields()
                signUpButton()
                Text("or")
                signInButton()
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func header() -> some View {
        VStack(spacing: 0) {
            Image("swift-laughing")
            Text("cloudList ☁️")
                .bold()
                .font(Font.largeTitle)
        }
    }
    
    @ViewBuilder
    private func inputFields() -> some View {
        VStack(alignment: .center, spacing: 16) {
            TextField(
                "Email Address",
                text: $emailAddress
            )
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            
            SecureField(
                "Password",
                text: $password
            )
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func signUpButton() -> some View {
        Button(
            action: {
                authModel.signUp(
                    emailAddress: emailAddress,
                    password: password
                )
            },
            label: {
                Text("Sign Up")
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                    .padding(.horizontal)
            }
        )
    }
    
    @ViewBuilder
    private func signInButton() -> some View {
        Button(
            action: {
                authModel.signIn(
                    emailAddress: emailAddress,
                    password: password
                )
            },
            label: {
                Text("Sign In")
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                    .padding(.horizontal)
            }
        )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .previewLayout(.sizeThatFits)
    }
}

