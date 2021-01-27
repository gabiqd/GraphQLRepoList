//
//  RepositoryListItemView.swift
//  GraphQLRepoList
//
//  Created by Gabriel on 27/01/2021.
//

import SwiftUI

struct RepositoryListItemView: View {
    @ObservedObject var repositoryViewModel: RepositoryViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            if let image = repositoryViewModel.imageStorage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32.0, height: 32.0)
                    .clipShape(Circle())
            } else {
                Image("defaultProfileImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32.0, height: 32.0)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text("\(repositoryViewModel.title)")
                    .font(.headline)
                Text("\(repositoryViewModel.owner)")
                    .font(.subheadline)
                Text("Stars: \(repositoryViewModel.numberOfStars)")
                    .font(.footnote)
            }
            
        }
    }
}
