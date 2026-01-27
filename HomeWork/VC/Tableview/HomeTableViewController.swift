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
        configSpinner()
        configTableView()
        updata()
        DispatchSerialQueue.main.asyncAfter(deadline: .now() + 2) { self.tableView.reloadData() }
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
        for model in unsplashModels {
            guard let url = URL(string: model.urls.regular!) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                let image = UIImage(data: data)
                if image != nil {
                    DispatchQueue.main.async {
                        self.imageArray.append(image ?? UIImage(systemName: "swift")!)
                        print("imageArray count:", self.imageArray.count)
                    }
                }
                else { print("nil") }
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
        tableView.register(CellCustom.self, forCellReuseIdentifier: CellCustom.identifier)
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
        self.spinner.stopAnimating()
        return cell
    }
    
}

//MARK: didSelectRowAt
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = DetailViewController()

        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            DetailViewController.image.image = image
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
        }
        else {
            print("nema u cache")
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
            DetailViewController.image.load(from: unsplashModels[indexPath.row].urls.full!)
        }

        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true)
   }
}
