//
//  DatailViewController.swift
//  HomeWork
//
//  Created by VP on 12.01.2026.
//

import BlurHash
import UIKit

final class DetailViewController: UIViewController {
    private let model: UnsplashModel
    private lazy var urlForCache = model.urls.small
    private lazy var urlForImageFullScreen = model.urls.full
    private lazy var urlProfile = model.user.links?.html
    
    private lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit", for: .normal)
        button.addTarget(self, action: #selector(backTaped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var titleAuthor: UILabel = {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(tappedLabel))
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.text = model.user.name?.localizedUppercase
        label.textColor = .orange
        label.backgroundColor = .white.withAlphaComponent(0.2)
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapLabel)
        return label
    }()

    private lazy var titleForImage: UILabel = {
        let textview = UILabel()
        textview.text = model.alt_description ?? "The Swift 🫀😈"
        textview.textColor = .darkText
        textview.backgroundColor = .white.withAlphaComponent(0.5)
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.textAlignment = .center
        textview.numberOfLines = 0
        return textview
    }()

    private lazy var like: UIButton = {
        let like = UIButton()
        like.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        like.setImage(UIImage(systemName: "heart"), for: .selected)
        like.tintColor = .red
        like.addTarget(self, action: #selector(likeTaped), for: .touchUpInside)
        return like
    }()

    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.image = CacheService.shared.getObject(forKey: urlForCache as AnyObject) ?? UIImage(systemName: "swiftdata")
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        img.addGestureRecognizer(tapLabel)
        return img
    }()

    // MARK: - Init

    init(model: UnsplashModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        self.view.layer.contents = UIImage(blurHash: model.blur_hash!, size: CGSize(width: 35, height: 35))?.cgImage
        self.view.layer.contentsGravity = .resizeAspectFill
    }

    // MARK: - Actions

    @objc private func tappedLabel() {
        guard let urlProfile else { return }
        let web = WebView(url: urlProfile)
        let nav = UINavigationController(rootViewController: web)
        present(nav, animated: true)
    }

    @objc private func backTaped() { dismiss(animated: true) }
    
    @objc private func tappedImage() {
        print("tap - tap")
        guard let urlForImageFullScreen else { return }
        guard let url = URL(string: urlForImageFullScreen) else { return }
        
        let download = URLSession.shared.dataTask(
            with: URLRequest(url: url)) {[weak self] data, response, error in
                print("tap - tap")
                guard let self else { return }
                guard error == nil else { return }
                guard let data else { return }
                if UIImage(data: data) != nil {
                    DispatchQueue.main.async {
                        print("tap - download")
                        let alert = UIAlertController(title: "Full Screen", message: nil, preferredStyle: .alert)
                        let button = UIAlertAction(title: "Ok", style: .cancel) { _ in
                            alert.dismiss(animated: true)
                        }
                        alert.addAction(button)
                        self.present(alert, animated: true)
                        print("tap - alert")
                    }
                }
            }
        download.resume()
    }


    @objc private func likeTaped() {
        like.isSelected.toggle()
        let alert = UIAlertAction(title: "Ok", style: .default)
        let uIAlertController = UIAlertController(
            title: "Like ❤️",
            message: "You liked this image",
            preferredStyle: .actionSheet
        )
        uIAlertController.addAction(alert)
        present(uIAlertController, animated: true)
    }

    // MARK: - UI Setup

    private func setLayout() {
        view.addSubview(imageView)
        view.addSubview(titleForImage)
        view.addSubview(buttonBack)
        view.addSubview(titleAuthor)
        view.addSubview(like)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleForImage.translatesAutoresizingMaskIntoConstraints = false
        titleAuthor.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        like.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
            buttonBack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            buttonBack.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            buttonBack.widthAnchor.constraint(equalToConstant: 50),
            buttonBack.heightAnchor.constraint(equalToConstant: 25),
            
            titleAuthor.leadingAnchor.constraint(greaterThanOrEqualTo: buttonBack.trailingAnchor,constant: 25),
            titleAuthor.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor, constant: -2),
            titleAuthor.centerYAnchor.constraint(equalTo: buttonBack.centerYAnchor),
            titleAuthor.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            like.centerYAnchor.constraint(equalTo: titleAuthor.centerYAnchor),
            like.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            
            titleForImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleForImage.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleForImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }
}

//#Preview{
//    DetailViewController(model: mock)
//}
