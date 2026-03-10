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
    private lazy var urlForProfile = model.user.links?.html

    private lazy var titleAuthor: UILabel = {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(tappedLabel))
        let label = UILabel()
        label.text = model.user.name?.localizedUppercase
        label.textColor = .orange
//        label.backgroundColor = .white.withAlphaComponent(0.2)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
//        label.sizeToFit()
//        label.textAlignment = .center
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

    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.image = CacheService.shared.getObject(forKey: urlForCache as AnyObject) ?? UIImage(systemName: "swiftdata")
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedImage)))
        return img
    }()
    
//    MARK: - UI Button
    private lazy var like: UIBarButtonItem = {
        let like = UIBarButtonItem()
        like.image = like.isSelected ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        like.tintColor = .red
        like.hidesSharedBackground = true
        like.action = #selector(likeTaped)
        like.target = self
        return like
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
        configNavBar()
    }

    // MARK: - Actions
    @objc private func tappedLabel() {
        guard let urlForProfile else { return }
        let web = WebView(url: urlForProfile)
        let nav = UINavigationController(rootViewController: web)
        present(nav, animated: true)
    }
    
    @objc private func tappedImage() {
        let indicate = createIndicator()
        indicate.startAnimating()
        
        guard let urlForImageFullScreen else { return }
        guard let url = URL(string: urlForImageFullScreen) else { return }
        
        let download = URLSession.shared.dataTask(
            with: URLRequest(url: url)) {[weak self] data, response, error in
                guard let self,
                        error == nil,
                        let data else { return }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let vcFull = FullScreenViewController(image: image)
                        self.navigationController?.pushViewController(vcFull, animated: true)
                        indicate.stopAnimating()
                    }
                }
            }
        download.resume()
    }


    @objc private func likeTaped() {
        like.isSelected.toggle()
        let alert = UIAlertAction(title: "Ok", style: .default)
        let uIAlertController = UIAlertController( title: "Like ❤️", message: "You liked this image", preferredStyle: .actionSheet)
        uIAlertController.addAction(alert)
        present(uIAlertController, animated: true)
    }
    
    func createIndicator() -> UIActivityIndicatorView {
        let indicate = UIActivityIndicatorView(style: .large)
        self.view.addSubview(indicate)
        indicate.center = view.center
        indicate.color = .black
        return indicate
    }
    
    // MARK: - UI Setup
    private func configNavBar() {
        navigationItem.titleView = titleAuthor
        navigationItem.rightBarButtonItem = like
    }
    
    private func setLayout() {
        view.addSubview(imageView)
        view.addSubview(titleForImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleForImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),

            titleForImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleForImage.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -50),
            titleForImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }
}

//#Preview{
//    DetailViewController(model: mock)
//}
