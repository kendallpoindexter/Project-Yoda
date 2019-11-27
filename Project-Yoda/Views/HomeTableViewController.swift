//
//  ViewController.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import UIKit

class HomeTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    let viewModel = HomeTableViewModel()



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        loadData()
    }

    private func loadData() {
        viewModel.getCharacters { (result) in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension HomeTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //How should I handle this optional value here? I set it to the known number of total characters at the time of this writting
        return viewModel.totalCharacterCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if isLoadingCell(for: indexPath) {
            cell.textLabel?.text = "Cell is loading"
           } else {
            cell.textLabel?.text = viewModel.characters[indexPath.row].name
           }
        return cell
    }

}

extension HomeTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.getCharacters { (result) in
               switch result {
               case .success(let newIndexPathsToReload):
                guard !newIndexPathsToReload.isEmpty else {
                    tableView.reloadData()
                    return
                }

                let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
                self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
               case .failure(let error):
                   print(error)
               }
           }
        }
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
           return indexPath.row >= viewModel.characters.count
       }

       func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
         let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
         let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
         return Array(indexPathsIntersection)
       }


}

extension HomeTableViewController: UITableViewDelegate {

}

