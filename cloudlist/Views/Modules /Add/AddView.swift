//
//  AddView.swift
//  todoBASE
//
//  Created by Matvii Sakhnenko on 05/10/2022.
//

import SwiftUI

struct AddView: View {
    private enum Constants {
        static let textFieldTitle = "what do you need to do ?"
        static let navigationTitle = "add an Item 💨"
    }
    
    @Binding var todoItemText: String
    @EnvironmentObject var viewModel: ListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var attempts: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                TextField(Constants.textFieldTitle, text: $todoItemText)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .cornerRadius(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.lavenderGray.opacity(0.8))
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    }
                
                Button {
                    viewModel.createAndAppend()
                    withAnimation(.default) {
                        self.attempts += 1
                    }
                    if !viewModel.isEmptyField {
                        dismiss()
                        viewModel.currentToDoItemText = ""
                    }
                } label: {
                    Label("add", systemImage: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .labelStyle(.iconOnly)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.theme.cloudBlue)
                        .background() 
                        .cornerRadius(10)
                        .modifier(Shake(animatableData: CGFloat(attempts)))
                }

            }
            .padding(16)
        }
        .navigationTitle(Constants.navigationTitle)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView(todoItemText: .constant("buy a car"))
        }
    }
}
