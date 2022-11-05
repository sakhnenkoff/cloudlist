//
//  CompositionView.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 05/11/2022.
//

import UIKit
import SwiftUI

struct CompositionView: View {
    @Binding var thoughtText: String
    @Environment(\.dismiss) var dismiss
    private let postItem: () -> Void
    
    init(
        thoughtText: Binding<String>,
        postItem: @escaping () -> Void
    ) {
        self._thoughtText = thoughtText
        self.postItem = postItem
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            topButtons()
            textView()
        }
    }
    
    @ViewBuilder
    private func topButtons() -> some View {
        HStack {
            Button(
                action: {
                    dismiss()
                },
                label: {
                    Text("dismiss")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(
                            Capsule()
                                .foregroundColor(.theme.lavenderGray)
                        )
                }
            )
            
            Spacer()
            
            Button(
                action: {
                    postItem()
                    dismiss()
                },
                label: {
                    Text("add")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(
                            Capsule()
                                .foregroundColor(.theme.lavenderGray)
                        )
                }
            )
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func textView() -> some View {
        ZStack(alignment: .topLeading) {
            if thoughtText.isEmpty {
                Text("What's on your mind?")
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .foregroundColor(.gray)
            }
            TextEditor(text: $thoughtText)
                .padding(.horizontal, 4)
                .background(.clear)
        }
    }
}

struct CompositionView_Previews: PreviewProvider {
    static var previews: some View {
        CompositionView(
            thoughtText: .constant(""),
            postItem: {}
        )
        .previewLayout(.sizeThatFits)
    }
}

