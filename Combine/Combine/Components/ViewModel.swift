//
//  ViewModel.swift
//  CombinePractice
//
//  Created by Jawad Ali on 02/02/2021.
//  Copyright © 2021 Jawad Ali. All rights reserved.
//
import UIKit
import Combine
import SwiftUI
class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published  var keyWordSearch = ""
    
    private let provider: FilmsProviderType
    init(filmProvider: FilmsProviderType) {
        provider = filmProvider
        $keyWordSearch.receive(on: RunLoop.main).debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { (_) in
                self.fetchMovies()
        }.store(in: &cancellables)
    }
    
    var diffableDataSource: MoviesTableViewDiffableDataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<String?, Result>()
    
    private func fetchMovies() {
        print("fetch:\(keyWordSearch)")
        provider.fetchFilms(keyword: keyWordSearch).receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                if case let .failure(error) = error {
                    print(error.localizedDescription)
                }
            }) { [unowned self](films) in
                self.snapshot.deleteAllItems()
                self.snapshot.appendSections([""])
                
                if let result = films.results, !result.isEmpty {
                    self.snapshot.appendItems(result, toSection: "")
                    self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
                } else {
                     self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
                }
        }.store(in: &cancellables)
        
    }
}
