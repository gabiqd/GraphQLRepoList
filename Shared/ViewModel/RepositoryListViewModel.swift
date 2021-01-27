//
//  RepositoryListViewModel.swift
//  GraphQLRepoList
//
//  Created by Gabriel on 25/01/2021.
//

import Foundation
import Combine

class RepositoryListViewModel: ObservableObject {
    @Published private(set) var repositoriesViewModel: [RepositoryViewModel] = []
    @Published private(set) var isLoading = false
    private(set) var hasNextPage = true
    private var networkService = NetworkService()
    
    func fetchIfNeeded(currentRepository: RepositoryViewModel? = nil) {
        let lastCursor = repositoriesViewModel.last?.cursor
        
        if currentRepository?.cursor == lastCursor && hasNextPage {
            isLoading.toggle()
            networkService.submit(queryString: "GraphQL", cursor: lastCursor, completion: { [weak self] result in
                guard let sself = self else { return }
                sself.isLoading.toggle()
                
                switch result {
                case .success(let response):
                    let networkSerivce = NetworkService()
                    sself.repositoriesViewModel += response.repositories.map{RepositoryViewModel(repository: $0, imageService: networkSerivce)}
                    sself.hasNextPage = response.hasNextPage
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
