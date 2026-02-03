//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

final class HomeTableViewController: UITableViewController {
    private var currentPage = 1
    private var isLoadingList = false
    
    private let dashBreakScroll: CGFloat = 300
    
    private var unsplashModels: [UnsplashModel] = []
    private var temperModels: [UnsplashModel] = []
    private var imageArray : [UIImage] = []
    private let cache = NSCache<AnyObject, UIImage>()
    private let spinner = UIActivityIndicatorView(style: .large)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updata(for: currentPage)
        configSpinner()
        configTableView()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - dashBreakScroll  && !isLoadingList{
               self.isLoadingList = true
               self.loadMoreItemsForList()
           }
       }
    
    private func loadMoreItemsForList(){
        currentPage += 1
        updata(for: currentPage)
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

    private func updata(for page: Int) {
        APIManager.shared.getImage(page: page) { [weak self] UnsplashModels in
            DispatchQueue.main.async {
                guard let self else { return }
                self.temperModels = UnsplashModels
                self.getImageForCell()
            }
        }
    }
    
    private func getImageForCell() {
        unsplashModels.append(contentsOf: temperModels)
        print("count temperModels: ", temperModels.count)
        for model in temperModels {
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
                    print(self.unsplashModels.count)
                    
                    if self.imageArray.count == self.unsplashModels.count {
                        self.isLoadingList = false
                        self.tableView.reloadData()
                        if self.spinner.isAnimating { self.spinner.stopAnimating() }
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
