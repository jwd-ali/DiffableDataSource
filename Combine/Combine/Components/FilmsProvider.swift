//
//  MovieProvider.swift
//  CombinePractice
//
//  Created by Jawad Ali on 04/02/2021.
//  Copyright © 2021 Jawad Ali. All rights reserved.
//

import Foundation
import Combine

protocol FilmsProviderType {
    /// Fetch currently available movies
  func fetchFilms(keyword: String) -> AnyPublisher<Films, NetworkRequestError>
}

////// A class encapsulating logic to provide content for movies
final class FilmsProvider: FilmsProviderType {
    
      //MARK:- Properties
    typealias ResponseType = Films
    private let movieAPI: FilmsAPI
    
     //MARK:- Initlializer
    init(movieAPI: FilmsAPI = NetworkManager.getSharedInstance()) {
           self.movieAPI = movieAPI
       }
    
    func fetchFilms(keyword: String) -> AnyPublisher<Films, NetworkRequestError> {
        movieAPI
            .requestFilms(keyword: keyword)
            .decode(type: Films.self, decoder: JSONDecoder())
            .mapError {error in
                if let error = error as? NetworkRequestError {
                        return error
                    } else {
                        return NetworkRequestError.serverError(error: error.localizedDescription)
                    }
                }
                .eraseToAnyPublisher()
        }
    
}
/// A type representing Movies required network data access
protocol FilmsAPI {
    func requestFilms(keyword: String) -> AnyPublisher<Data, NetworkRequestError>
}
extension NetworkManager: FilmsAPI {
    private var API_KEY: String { "k_0hpcd8sn"}
    private var endpoint: String{ "https://imdb-api.com/en/API/SearchMovie/"}
    func requestFilms(keyword: String) -> AnyPublisher<Data, NetworkRequestError> {
        execute(request: EndPointProvider(with: "\(endpoint)/\(API_KEY)/\(keyword)"))
    }
}
