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
    
    private let dashBreakScroll: CGFloat = 500
    private var currentPage = 1
    private var isLoadingList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updata(for: currentPage)
        configTableView()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - dashBreakScroll  && !isLoadingList{
            self.loadMoreItemsForList()
            self.isLoadingList = true
        }
    }
    
    private func loadMoreItemsForList(){
        currentPage += 1
        updata(for: currentPage)
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellCustom.self, forCellReuseIdentifier: CellCustom.identifier)
        tableView.rowHeight = 250
    }
    
    private func updata(for page: Int) {
        APIManager.shared.getImage(page: page) { [weak self] newUnsplashModels in
            DispatchQueue.main.async {
                guard let self else { return }
                let startIndex = self.unsplashModels.count
                
                self.unsplashModels.append(contentsOf: newUnsplashModels)
                self.isLoadingList = false
                
                let newIndexPaths = (startIndex..<self.unsplashModels.count).map {
                    IndexPath(row: $0, section: 0)
                }
                self.tableView.insertRows(at: newIndexPaths, with: .fade)
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
        let imageUrl = modelUnsplash.urls.small
        
        cell.imageCell.image = nil
        cell.titleCell.text = nil
        cell.imageCell.image = UIImage(blurHash: modelUnsplash.blur_hash!, size: CGSize(width: 150, height: 200))
        cell.titleCell.text = modelUnsplash.alt_description

        if let image = CacheService.shared.getObject(forKey: imageUrl as AnyObject) {
            cell.imageCell.image = image
        }
        else {
            LoadImage.shared.getImage(from: imageUrl) { image in
                guard let image else { return }
                DispatchQueue.main.async {
                    cell.imageCell.image = image
                    cell.titleCell.text = modelUnsplash.alt_description
                }
            }
        }
        return cell
    }
}

//MARK: didSelectRowAt
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = DetailViewController(model: unsplashModels[indexPath.row])
        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true)
    }
}
