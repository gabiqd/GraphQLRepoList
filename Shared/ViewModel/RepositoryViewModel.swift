//
//  RepositoryViewModel.swift
//  GraphQLRepoList
//
//  Created by Gabriel on 24/01/2021.
//

import Foundation
import UIKit

class RepositoryViewModel: Identifiable, ObservableObject {
    private let repository: Repository
    private let imageService: NetworkService
    
    @Published var imageStorage: UIImage? = nil

    init(repository: Repository, imageService: NetworkService) {
        self.repository = repository
        self.imageService = imageService
        
        self.fetchImage()
    }
    
    var title: String {
        return repository.title
    }
    
    var owner: String {
        return repository.owner
    }
    
    var numberOfStars: Int {
        return repository.numberOfStars
    }
    
    var cursor: String {
        return repository.cursor
    }
    
    func fetchImage() {
        guard let url = repository.ownerAvatarURL else { return }
        imageService.fetchImage(imageURL: url) { [weak self] (result) in
            guard let sself = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    sself.imageStorage = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
