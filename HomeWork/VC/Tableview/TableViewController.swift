//
//  ViewController.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

final class TableViewController: UITableViewController {
    private var unsplashModels: [UnsplashModel] = []
    private var readyViewFormModelsURL: [UIImageView] = []
    private let cache = NSCache<AnyObject, UIImageView>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        updata()
        
        DispatchSerialQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadImageForCell()
            print("tableview reloadData after 2 sec")
        }

        DispatchSerialQueue.main.asyncAfter(deadline: .now() + 4) {
            print("try reload TableView after 4 sec")
            self.tableView.reloadData()
        }

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
            }
        }
    }

    private func loadImageForCell() {
        if !unsplashModels.isEmpty {
            for image in unsplashModels {
                let imageReady = UIImageView()
                    imageReady.load(from: image.urls.regular!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if imageReady.image == nil {
                        print("не загрузилось")
                    } else {
                        self.readyViewFormModelsURL.append(imageReady)
                        print(imageReady.image ?? "нет")
                    }
                }
            }
        } else {
            print("pusto v unsplashModels")
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
        }
        else {
            cache.setObject(readyViewFormModelsURL[indexPath.row], forKey: indexPath.row as AnyObject)
            cell.imageCell.image = readyViewFormModelsURL[indexPath.row].image
            cell.titleCell.text = modelSplh.alt_description
        }
        return cell
    }
}

//MARK: didSelectRowAt
extension TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = DetailViewController()

        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            DetailViewController.image.image = image.image
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
        }
        else {
            print("nema u cache")
            DetailViewController.titleImage.text = unsplashModels[indexPath.row].alt_description
            DetailViewController.image.load(from: unsplashModels[indexPath.row].urls.full!)
        }

        DetailViewController.modalPresentationStyle = .fullScreen
        present(DetailViewController, animated: true) {
            tableView.backgroundColor = .blue
        }
   }
}
