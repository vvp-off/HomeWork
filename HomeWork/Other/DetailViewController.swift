//
//  DatailViewController.swift
//  HomeWork
//
//  Created by VP on 12.01.2026.
//

import UIKit

class DetailViewController: UIViewController {
    
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
        textview.text = "The Swift Programming Language 🫀😈"
        textview.textColor = .darkText
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.textAlignment = .center
        textview.numberOfLines = 0
        textview.backgroundColor = .purple.withAlphaComponent(0.5)
        return textview
    }()
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "swiftdata")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout() {
        view.backgroundColor = .brown
        view.addSubview(image)
        view.addSubview(titleImage)
        view.addSubview(buttonBack)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.frame = CGRect(x: 20, y: 60, width: 50, height: 30)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
            titleImage.leadingAnchor.constraint(equalTo: image.leadingAnchor),
//            titleImage.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 10),
            titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            titleImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
}
