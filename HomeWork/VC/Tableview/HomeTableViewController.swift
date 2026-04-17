//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit
import BlurHash

final class HomeTableViewController: UITableViewController {
    var unsplashModels: [UnsplashModel] = []
    
    private let dashBreakScroll: CGFloat = 500
    private var currentPage = 1
    private var isLoadingList = false
    private let refresh = UIRefreshControl()
    private lazy var footerLoader = createFooter()
    
    // MARK: - Lifecycl
    override func viewDidLoad() {
        super.viewDidLoad()
        update(for: currentPage)
        configTableView()
        configureRefreshControl()
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - dashBreakScroll  && !isLoadingList{
            self.loadMoreItemsForList()
            self.isLoadingList = true
            configFooter()
        }
    }
    
    // MARK: - Private Methods
    private func configFooter() {
        let footerHeight: CGFloat = 80
        let containerForFooter = UIView(frame: .init(x: 0, y: 0, width: tableView.bounds.width, height: footerHeight))
        
        containerForFooter.addSubview(footerLoader)
        
        footerLoader.translatesAutoresizingMaskIntoConstraints = false
        footerLoader.frame.size.width = tableView.bounds.width
        footerLoader.frame.size.height = 80
        
        NSLayoutConstraint.activate([
            footerLoader.centerXAnchor.constraint(equalTo: containerForFooter.centerXAnchor),
            footerLoader.centerYAnchor.constraint(equalTo: containerForFooter.centerYAnchor)
        ])
        
        tableView.tableFooterView = containerForFooter
    }
    
    private func loadMoreItemsForList(){
        currentPage += 1
        self.update(for: self.currentPage) { self.tableView.tableFooterView = nil }
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellCustom.self, forCellReuseIdentifier: CellCustom.identifier)
        tableView.rowHeight = 250
        tableView.refreshControl = refresh
        tableView.separatorColor = .lightGray
        tableView.separatorStyle = .singleLine
    }
    
    private func configureRefreshControl() {
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
    
    private func createFooter() -> UIStackView {
        let stack = UIStackView()
        
        let label: UILabel = {
            let lab = UILabel()
            lab.text = "Loading..."
            return lab
        }()
        
        let spiner: UIActivityIndicatorView = {
            let spiner = UIActivityIndicatorView()
            spiner.color = .gray
            spiner.startAnimating()
            return spiner
        }()
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(spiner)
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }
    
    private func update(for page: Int, completion: (() -> Void)? = nil) {
        APIManager.shared.getImage(page: page) { [weak self] newUnsplashModels in
            switch newUnsplashModels {
            case .success(let success):
                DispatchQueue.main.async {
                    guard let self else { return }
                    let startIndex = self.unsplashModels.count
                    
                    self.unsplashModels.append(contentsOf: success)
                    self.isLoadingList = false
                    
                    let newIndexPaths = (startIndex..<self.unsplashModels.count).map {
                        IndexPath(row: $0, section: 0)
                    }
                    self.tableView.insertRows(at: newIndexPaths, with: .fade)
                    completion?()
                }
            case .failure(let failure):
                print("error: \(failure)")
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
        
        if let blur = modelUnsplash.blur_hash {
            cell.imageCell.image = UIImage(blurHash: blur, size: CGSize(width: 150, height: 200))
        }
        else {cell.imageCell.image = UIImage(systemName: "swift") }
        
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
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


// MARK: - Previews
#Preview { HomeTableViewController() }
