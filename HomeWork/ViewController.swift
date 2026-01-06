//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class ViewController: UITableViewController {
    
    var unsplashModelsArray: [String] = []

    override func viewDidLoad() {
        view.backgroundColor = .darkGray
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        APIManager.shared.getImage { [weak self] strUrl in
            DispatchQueue.main.async {
                guard let self else { return }
                self.unsplashModelsArray.append(strUrl)
                self.tableView.reloadData()
            }
        }
        print(unsplashModelsArray.count)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unsplashModelsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        let urlString = unsplashModelsArray[indexPath.row]
        cell.imageView?.image = nil
        cell.imageView?.load(from: urlString)
        return cell
    }

}

