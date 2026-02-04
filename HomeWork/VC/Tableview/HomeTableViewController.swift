//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//
import BlurHash
import UIKit

final class HomeTableViewController: UITableViewController {
    private var unsplashModels: [UnsplashModel] = []
    
    let cache = NSCache<AnyObject, UIImage>()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let dashBreakScroll: CGFloat = 300
    
    private var currentPage = 1
    private var isLoadingList = false
    
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
                self.unsplashModels.append(contentsOf: UnsplashModels)
                self.spinner.isHidden = true
                self.isLoadingList = false
                print(self.isLoadingList)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCustom.identifier, for: indexPath) as! CellCustom
        let modelUnsplash = unsplashModels[indexPath.row]
        
        if let image = cache.object(forKey: modelUnsplash.urls.full as AnyObject) {
            cell.imageCell.image = image
            cell.titleCell.text = modelUnsplash.alt_description
        }
        else {
            let blurPlaceHolder = UIImage(blurHash: modelUnsplash.blur_hash!, size: CGSize(width: 35, height: 35))
            cell.imageCell.image = blurPlaceHolder
            guard
                let urlString = modelUnsplash.urls.full,
                let url = URL(string: urlString)
            else { return cell }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard
                    let data,
                    let image = UIImage(data: data)
                else {
                    print("error from urlSession data/image")
                    return
                }
                
                DispatchQueue.main.async() {
                    cell.imageCell.image = image
                    cell.titleCell.text = modelUnsplash.alt_description
                    self.cache.setObject(image, forKey: modelUnsplash.urls.full as AnyObject)
                }
            }
            task.resume()
        }
        return cell
    }
    
}

//MARK: didSelectRowAt
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = DetailViewController(model: unsplashModels[indexPath.row], cache: cache)
        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true)
    }
}
