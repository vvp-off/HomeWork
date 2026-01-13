//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class TableViewController: UITableViewController {
    var unsplasModels: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updata()
    }

   private func updata() {
        APIManager.shared.getImage { [weak self] imageUrls in
            DispatchQueue.main.async {
                guard let self else { return }
                self.unsplasModels = imageUrls
                self.tableView.reloadData()
            }
        }
    }
}
//MARK: numberOfRowsInSection
extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unsplasModels.count
    }
}

//MARK: cellForRowAt
extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let urlString = unsplasModels[indexPath.row]
        let cellCast = CellCustom(style: .subtitle, reuseIdentifier: CellCustom.identifier)
        cellCast.imageCell.image = nil
        cellCast.imageCell.load(from: urlString)
        cellCast.titleCell.text = unsplasModels[indexPath.row]
        tableView.rowHeight = 200
        cellCast.setConstraint()
        return cellCast
    }
}
