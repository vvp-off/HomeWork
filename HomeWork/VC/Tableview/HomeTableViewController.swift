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
    private var currentPage = 12
    private var isLoadingList = false
    private let refresh = UIRefreshControl()
    private let viewFooter = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update(for: currentPage)
        configTableView()
        configureRefreshControl()
        viewFooter.image = UIImage(named: "AppIcon")
    }
    
// MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - dashBreakScroll  && !isLoadingList{
            self.loadMoreItemsForList()
            self.isLoadingList = true
        }
    }
    
// MARK: - Private Methods
 
    private func loadMoreItemsForList(){
        currentPage += 1
        update(for: currentPage)
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellCustom.self, forCellReuseIdentifier: CellCustom.identifier)
        tableView.rowHeight = 250
        tableView.refreshControl = refresh
    }
    
    private func configureRefreshControl() {
        print(self)
        refresh.addTarget(self, action: #selector(sortedTable), for: .valueChanged)
        refresh.tintColor = .blue
        refresh.attributedTitle = NSAttributedString(string: ("Loading..."))
    }
    
    @objc private func sortedTable() {
        currentPage += 1
        isLoadingList = false
        unsplashModels.removeAll()
        tableView.reloadData()
        update(for: currentPage) { self.refresh.endRefreshing() }
    }
    
    private func update(for page: Int, completion: (() -> Void)? = nil) {
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
                completion?()
            }
        }
    }
}

// MARK: - NumberOfRowsInSection

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unsplashModels.count
    }
}

// MARK: - CellForRowAt

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellCustom.identifier, for: indexPath) as! CellCustom
        let modelUnsplash = unsplashModels[indexPath.row]
        let imageUrl = modelUnsplash.urls.small
        
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

// MARK: - DidSelectRowAt

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(model: unsplashModels[indexPath.row])
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
}
