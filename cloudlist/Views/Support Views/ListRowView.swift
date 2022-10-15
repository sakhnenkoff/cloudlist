//
//  ListRowView.swift
//  todoBASE
//
//  Created by Matvii Sakhnenko on 05/10/2022.
//

import SwiftUI

struct ListRowView: View {
    @EnvironmentObject var viewModel: ListViewModel
    
    var item: Item
    let position: Int
    
    private var priorityColor: Color {
        switch position {
        case 1...5:
            return .red
        case 6...10:
            return .orange
        case 11...:
            return .teal
        default:
            return .red
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .theme.cloudBlue : .gray.opacity(0.6))
                .onTapGesture {
                    viewModel.onUpdateItem(item)
                }
                .animation(.easeIn(duration: 0.3), value: item.isCompleted)
            
            Text(item.title)
                .font(.headline)
            
            Spacer()
            
            Text("\(position)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(priorityColor)
            
        }
        .opacity(item.isCompleted ? 0.6 : 1)
        .animation(.easeIn(duration: 0.4), value: item.isCompleted)
        .overlay(alignment: .center) {
            if item.isCompleted {
                Divider()
            }
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
    
    init(_ item: Item, position: Int) {
        self.item = item
        self.position = position
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListRowView(.stubItem1, position: 1)
            ListRowView(.stubItem2, position: 2)
            ListRowView(.stubItem3, position: 3)
        }
        .previewLayout(.sizeThatFits)
    }
}
