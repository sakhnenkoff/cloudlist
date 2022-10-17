//
//  ListView.swift
//  todoBASE
//
//  Created by Matvii Sakhnenko on 05/10/2022.
//

import SwiftUI

struct ListView: View {
    private enum Constants {
        static let navigationTitle = "cloudList ☁️"
        static let cloudIsEmptyText = "cloud is empty"
        static let cloudSunImageName = "cloud.sun"
        static let addText = "add"
    }
    
    @EnvironmentObject var viewModel: ListViewModel
    
    var body: some View {
        Group {
            if !viewModel.itemsEmpty {
                makeListView()
            } else {
                VStack(spacing: 2) {
                    Image(systemName: Constants.cloudSunImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    Text(Constants.cloudIsEmptyText)
                        .font(.callout)
                }
                .animation(.easeIn(duration: 2), value: viewModel.itemsEmpty) // does not work :(
                .opacity(0.5)
            }
        }
        .navigationTitle(Constants.navigationTitle)
        .onAppear {
            viewModel.viewWillAppear()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !viewModel.itemsEmpty { EditButton() } else { EmptyView() }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(Constants.addText) {
                    AddView(todoItemText: $viewModel.currentToDoItemText)
                }
            }
        }
        .tint(.theme.cloudBlue)
    }
    
    func makeListView() -> some View {
        List {
            ForEach(viewModel.items) { ListRowView($0, position: viewModel.position(of: $0)) }
                .onDelete(perform: viewModel.deleteItem)
                .onMove(perform: viewModel.moveItem)
        }
        .listStyle(.plain)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
                .environmentObject(ListViewModel(domainModel: AppFactory.createDomainModel()))
        }
    }
}
