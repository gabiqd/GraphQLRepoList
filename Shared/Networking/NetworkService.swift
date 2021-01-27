//
//  NetworkService.swift
//  GraphQLRepoList
//
//  Created by Gabriel on 24/01/2021.
//

import Foundation
import Apollo
import UIKit

class NetworkService {
    lazy private var apollo: ApolloClient? = {
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        
        let client = URLSessionClient()
        let provider = NetworkInterceptorProvider(store: store, client: client)
        guard let url = NetworkEndpoints.repositories.url else { return nil }
        
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                 endpointURL: url)
        
        return ApolloClient(networkTransport: requestChainTransport,
                            store: store)
    }()
    
    func submit(queryString: String, cursor: String? = nil, completion: @escaping (Result<RepositoryList, Error>) -> Void) {
        
        if let cursor = cursor {
            submitWithQuery(query: SearchRepositoriesWithCursorQuery(cursorString: cursor, queryString: queryString)) { [weak self] (result) in
                guard let sself = self else { return }
                completion(sself.processResponse(result: result))
            }
        } else {
            submitWithQuery(query: SearchRepositoriesWithQuery(queryString: queryString)) { [weak self] (result) in
                guard let sself = self else { return }
                completion(sself.processResponse(result: result))
            }
        }
    }
    
    private func processResponse(result: Result<ResultMap, Error>) -> Result<RepositoryList, Error> {
        switch result {
        case .success(let resultMap):
            var repositories = [Repository]()
            
            guard let search = resultMap["search"] as? [String: Any], let pageInfo = search["pageInfo"] as? [String: Any] else {
                return .failure(NetworkError.decodingError)
            }
            
            let hasNextPage = pageInfo["hasNextPage"] as? Bool ?? false
            let edges = search["edges"] as! [[String: Any]]
            
            repositories = edges.compactMap { edge in
                guard let cursor = edge["cursor"] as? String else { return nil }
                guard let repositoryResultMap = edge["node"] as? ResultMap else { return nil }
                let repositoryData = RepositoryData.init(unsafeResultMap: repositoryResultMap)
                
                return Repository(repositoryData, cursor: cursor)
            }
            
            return .success(RepositoryList(repositories: repositories, hasNextPage: hasNextPage))
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func submitWithQuery<Query: GraphQLQuery>(query: Query, completion: @escaping (Result<ResultMap, Error>) -> Void) {
        
        apollo?.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                guard let data = graphQLResult.data else { return }
                completion(.success(data.resultMap))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(imageURL url: URL, completition: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let posterData = try Data(contentsOf: url)
                guard let image = UIImage(data: posterData) else {
                    
                    completition(.failure(NetworkError.noImageError))
                    return
                }
                completition(.success(image))
            } catch (let error) {
                completition(.failure(error))
            }
        }
    }
}
