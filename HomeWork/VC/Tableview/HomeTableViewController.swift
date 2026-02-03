//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

final class HomeTableViewController: UITableViewController {
    private var unsplashModels: [UnsplashModel] = []
    
    private let cache = NSCache<AnyObject, UIImage>()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let dashBreakScroll: CGFloat = 300
    
    private var currentPage = 1
    private var isLoadingList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updata(for: currentPage)
        configSpinner()
        configTableView()
        tableView.reloadData()
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - dashBreakScroll  && !isLoadingList{
//               self.isLoadingList = true
//               self.loadMoreItemsForList()
//           }
//       }
    
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
                self.unsplashModels = UnsplashModels
                self.spinner.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: numberOfRowsInSection
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unsplashModels.count
    }
}

//MARK: cellForRowAt
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelUnsplash = unsplashModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCustom.identifier, for: indexPath) as! CellCustom
        
        guard
            let urlString = modelUnsplash.urls.full,
            let url = URL(string: urlString)
        else { return cell }
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard
                    let data,
                    let image = UIImage(data: data)
                else { return }
                
                cell.imageCell.image = image
                tableView.reloadData()
            }
            task.resume()
        }
        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            cell.imageCell.image = image
            cell.titleCell.text = modelUnsplash.alt_description
        }
        else {
            
            let image = UIImageView()
            image.load(from: modelUnsplash.urls.full!)
            while image.image == nil {
                cell.imageCell.image = UIImage(named: "swift")
            }
            cache.setObject(image.image!, forKey: indexPath.row as AnyObject)
            cell.imageCell.image = image.image
            cell.titleCell.text = modelUnsplash.alt_description
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
            let image = UIImageView()
            image.load(from: unsplashModels[indexPath.row].urls.full!)
            DetailViewController.imageView.image = image.image
        }

        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true)
   }
}
