//
//  CellCustom.swift
//  HomeWork
//
//  Created by VP on 09.01.2026.
//

import UIKit

final class CellCustom: UITableViewCell {
    static let identifier = "CellCustom"
    
    var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "swift")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var titleCell: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.textColor = .darkText
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0.8
        label.backgroundColor = .white.withAlphaComponent(0.4)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = UIImage(systemName: "swift")
        titleCell.text = "Hello"
    }
    
    private func setConstraint() {
        contentView.addSubview(imageCell)
        contentView.addSubview(titleCell)
        
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        titleCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titleCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
