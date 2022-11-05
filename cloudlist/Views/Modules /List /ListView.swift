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
    @EnvironmentObject var authService: AuthenticationService
    
    @State private var showingCompositionView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if !viewModel.itemsEmpty {
                    makeListView()
                        .disabled(viewModel.isDataLoading)
                } else if viewModel.shouldDisplayEmptyItemsView {
                    makeEmptyItemsView()
                }
                
                makeComposeButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if viewModel.isDataLoading && viewModel.itemsEmpty {
                    ProgressView("☁️ is loading")
                        .frame(width: 124, height: 124)
                        .progressViewStyle(.circular)
                        .background(Material.regularMaterial)
                        .cornerRadius(10)
                } else if viewModel.isDataLoading {
                    ProgressView()
                }
            }
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.viewWillAppear()
            }
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    if !viewModel.itemsEmpty { EditButton() } else { EmptyView() }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(Constants.addText) {
//                        AddView(todoItemText: $viewModel.currentToDoItemText)
//                    }
//                }
                makeSignOutButton()
            }
            .tint(.theme.lavenderGray)
        }
    }
    
    private func makeListView() -> some View {
        List {
            ForEach(viewModel.items) { ListRowView($0, position: viewModel.position(of: $0)) }
                .onDelete(perform: { indexset in
                    viewModel.deleteItem(indexSet: indexset)
                })
                .onMove(perform: viewModel.moveItem)
        }
        .listStyle(.insetGrouped)
    }
    
    private func makeEmptyItemsView() -> some View {
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

    private func makeSignOutButton() -> some View {
        Button(
            action: {
                authService.signOut()
            },
            label: {
                Text("Sign Out")
                    .bold()
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        Capsule()
                            .foregroundColor(Color.theme.lavenderGray)
                    )
            }
        )
    }
    
    private func makeComposeButton() -> some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Button(
                    action: {
                        showingCompositionView = true
                    },
                    label: {
                        Image(systemName: "plus")
                            .resizable()
                            .padding()
                            .frame(width: 50, height: 50)
                            .background(Color.theme.lavenderGray)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                )
                .padding(30)
                .fullScreenCover(isPresented: $showingCompositionView) {
                    CompositionView(
                        thoughtText: $viewModel.currentToDoItemText,
                        postItem: viewModel.createAndAppend
                    )
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
                .environmentObject(ListViewModel(domainModel: AppDependencyFactory.createDomainModel()))
        }
    }
}
