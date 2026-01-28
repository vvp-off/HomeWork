//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

final class HomeTableViewController: UITableViewController {
    private var unsplashModels: [UnsplashModel] = []
    private var imageArray : [UIImage] = []
    private let cache = NSCache<AnyObject, UIImage>()
    private let spinner = UIActivityIndicatorView(style: .large)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updata()
        configSpinner()
        configTableView()
        
    }

    private func configSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellCustom.self, forCellReuseIdentifier: CellCustom.identifier)
        tableView.rowHeight = 250
    }

    private func updata() {
        APIManager.shared.getImage { [weak self] modelsUnspl in
            DispatchQueue.main.async {
                guard let self else { return }
                self.unsplashModels = modelsUnspl
                self.getImageForCell()
            }
        }
    }
    
    private func getImageForCell() {
        let total = unsplashModels.count
        for model in unsplashModels {
            guard
                let urlString = model.urls.full,
                let url = URL(string: urlString)
            else { continue }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard
                    let data,
                    let image = UIImage(data: data)
                else { return }
                
                DispatchQueue.main.async {
                        self.imageArray.append(image)
                        print("imageArray count:", self.imageArray.count)
                    
                    if self.imageArray.count == total {
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                    }
                }
            }
            task.resume()
        }
    }
}

//MARK: numberOfRowsInSection
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageArray.count
    }
}

//MARK: cellForRowAt
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelSplh = unsplashModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCustom.identifier, for: indexPath) as! CellCustom
        
        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            cell.imageCell.image = image
            cell.titleCell.text = modelSplh.alt_description
        }
        else {
            cache.setObject(imageArray[indexPath.row], forKey: indexPath.row as AnyObject)
            cell.imageCell.image = imageArray[indexPath.row]
            cell.titleCell.text = modelSplh.alt_description
        }
        
        return cell
    }
    
}

//MARK: didSelectRowAt
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = DetailViewController()

        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            DetailViewController.imageView.image = image
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
        }
        else {
            print("no cache")
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
            DetailViewController.imageView.image = imageArray[indexPath.row]
        }

        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true)
   }
}
