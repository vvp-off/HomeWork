//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class TableViewController: UITableViewController {
    var unsplashModels: [UnsplashModel] = []
    let cache = NSCache<AnyObject, UIImageView>()
    

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
        
        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            cell.imageCell.image = image.image
            cell.titleCell.text = modelSplh.alt_description
        } else {
            let imagecell = UIImageView()
            imagecell.load(from: modelSplh.urls.full!)
            cache.setObject(imagecell, forKey: indexPath.row as AnyObject)
            cell.imageCell.load(from: modelSplh.urls.full!)
            cell.titleCell.text = modelSplh.alt_description
        }
        
        return cell
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = DetailViewController()
        
        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            DetailViewController.image.image = image.image
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
        } else {
//            let img = UIImageView()
//            img.load(from: unsplashModels[indexPath.row].urls.full!)
//            cache.setObject(img, forKey: indexPath.row as AnyObject)
            
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
            DetailViewController.image.load(from: unsplashModels[indexPath.row].urls.full!)
        }
        
        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true) {
            tableView.backgroundColor = .blue
        }
    }
}

