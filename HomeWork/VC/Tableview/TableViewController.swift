//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class TableViewController: UITableViewController {
    var unsplashModels: [UnsplashModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 250
        updata()
        
    }

   private func updata() {
       APIManager.shared.getImage { [weak self] modelsUnspl   in
            DispatchQueue.main.async {
                guard let self else { return }
                self.unsplashModels = modelsUnspl
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: numberOfRowsInSection
extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unsplashModels.count
    }
}

//MARK: cellForRowAt
extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelSplh = unsplashModels[indexPath.row]
        tableView.register(CellCustom.self, forCellReuseIdentifier: CellCustom.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCustom.identifier, for: indexPath) as! CellCustom
        cell.imageCell.load(from: modelSplh.urls.full)
        cell.titleCell.text = modelSplh.alt_description
        return cell
    }
}

