//
//  ContentView.swift
//  Shared
//
//  Created by Gabriel on 22/01/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var repositoriesViewModel = RepositoryListViewModel()
    
    var body: some View {
        List {
            repositoriesList
            if repositoriesViewModel.isLoading {
                loadingIndicator
            }
        }
        .onAppear{repositoriesViewModel.fetchIfNeeded()}
    }
    
    private var repositoriesList: some View {
        ForEach(repositoriesViewModel.repositoriesViewModel) { repositoryViewModel in
            RepositoryListItemView(repositoryViewModel: repositoryViewModel)
                .onAppear(perform: {
                    repositoriesViewModel.fetchIfNeeded(currentRepository: repositoryViewModel)
                })
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
