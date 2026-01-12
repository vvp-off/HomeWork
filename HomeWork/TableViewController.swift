//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class TableViewController: UITableViewController {
    var unsplashModels: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updata()
    }

    func updata() {
        APIManager.shared.getImage { [weak self] imageUrls in
            DispatchQueue.main.async {
                guard let self else { return }
                self.unsplashModels = imageUrls
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        let urlString = unsplashModels[indexPath.row]
        
        cell.imageView?.image = nil
        cell.imageView?.load(from: urlString)
        cell.imageView?.contentMode = .scaleToFill
        return cell
    }
}


// Это временное решение чтобы посмотреть как выглядят картинки. Нужно убрать и переделать правильно:
//        - создать класс для кастомной ячейки
//        - переписать загрузку картинки из extension на более стабильный способ.
        
//        let imageView = UIImageView(frame: cell.contentView.bounds)
//        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.load(from: urlString)
//
//        cell.contentView.addSubview(imageView)
