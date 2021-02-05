//
//  ViewController.swift
//  Combine
//
//  Created by Jawad Ali on 02/02/2021.
//  Copyright © 2021 Jawad Ali. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
class MoviesTableViewDiffableDataSource: UITableViewDiffableDataSource<String?, Result> {}

class MainView: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @ObservedObject private var viewModel = ViewModel(filmProvider: FilmsProvider())
    
    @Published var keyStroke: String = ""
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
           registerCell()
        setupObservers()
    }
}

// MARK: - Setup UI & Cells
private extension MainView {
    
    func setupObservers() {
        $keyStroke
            .receive(on: RunLoop.main)
            .sink {[weak self] in
                self?.viewModel.keyWordSearch = $0
        }.store(in: &cancellables)
        
        viewModel.diffableDataSource = MoviesTableViewDiffableDataSource(tableView: tableView) {
            (tableView, indexPath, model) -> UITableViewCell? in
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell
            else { return UITableViewCell() }
            
            cell.movieObject = model
            return cell
        }
        
        
    }
    
    
    func registerCell() {
        let movieCell = UINib(nibName: MovieCell.reuseIdentifier, bundle: nil)
        tableView.register(movieCell, forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }
}

//MARK: - UISearchBar Delegate
extension MainView: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyStroke = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.keyStroke = ""
    }
}
