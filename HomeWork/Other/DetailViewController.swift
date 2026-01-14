//
//  DatailViewController.swift
//  HomeWork
//
//  Created by VP on 12.01.2026.
//

import UIKit

class DetailViewController: UIViewController {
    let descriptionText: String = ""
    let imageUrl = ""

    lazy var titleImage: UILabel = {
        let textview = UILabel()
        textview.text = "The Swift Programming Language"
        textview.textColor = .darkText
        textview.font = UIFont.systemFont(ofSize: 25)
        return textview
    }()
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "swiftdata")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confegerUI()
//        updateImage()
    }
    
    func confegerUI() {
        view.backgroundColor = .brown
        view.addSubview(image)
        view.addSubview(titleImage)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            titleImage.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            titleImage.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 10)
        ])
    }
    
//    func updateImage() {
//        APIManager.shared.getImage { [weak self] imageUrls in
//            DispatchQueue.main.async {
//                guard let self else { return }
//                self.image.image = UIImage(data: try! Data(contentsOf: URL(string: imageUrls[0])!))
//            }
//        }
//    }
    
}
