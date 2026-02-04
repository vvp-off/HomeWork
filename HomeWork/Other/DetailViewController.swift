//
//  DatailViewController.swift
//  HomeWork
//
//  Created by VP on 12.01.2026.
//

import UIKit

final class DetailViewController: UIViewController {
    
    let cache: NSCache<AnyObject, UIImage>
    let model: UnsplashModel
    
    @objc func buttonBackTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit", for: .normal)
        button.addTarget(self, action: #selector(buttonBackTapped), for: .touchUpInside)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()

    lazy var titleImage: UILabel = {
        let textview = UILabel()
        textview.text = model.alt_description ?? "The Swift Programming Language 🫀😈"
        textview.textColor = .darkText
        textview.backgroundColor = .white.withAlphaComponent(0.5)
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.textAlignment = .center
        textview.numberOfLines = 0
        return textview
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.image = cache.object(forKey: model.urls.full as AnyObject) ?? UIImage(systemName: "swiftdata")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    init (model: UnsplashModel, cache: NSCache<AnyObject, UIImage>) {
        self.model = model
        self.cache = cache
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .darkGray
        view.addSubview(imageView)
        view.addSubview(titleImage)
        view.addSubview(buttonBack)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.frame = CGRect(x: 20, y: 60, width: 50, height: 30)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
            titleImage.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            titleImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
}
