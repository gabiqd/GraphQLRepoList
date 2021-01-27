//
//  Repository.swift
//  GraphQLRepoList
//
//  Created by Gabriel on 24/01/2021.
//

import Foundation

struct Repository {
    let title: String
    let owner: String
    let ownerAvatarURL: URL?
    let numberOfStars: Int
    let cursor: String
    
    init?(_ data: RepositoryData, cursor: String) {
        self.title = data.name
        self.owner = data.owner.login
        self.numberOfStars = data.stargazers.totalCount
        self.ownerAvatarURL = URL(string: data.owner.avatarUrl)
        self.cursor = cursor
    }
}
