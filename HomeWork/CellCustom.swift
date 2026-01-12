//
//  CellCustom.swift
//  HomeWork
//
//  Created by VP on 09.01.2026.
//

import UIKit

class CellCustom: UITableViewCell {
    
    static let identifier = "CellCustom"
   
    var imageCell: UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    var titleCell: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    func setLayot() {
        NSLayoutConstraint.activate([
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    func setData(frome model: UnsplashModel) {
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayot()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

let cast = CellCustom(
    style: .default,
    reuseIdentifier: CellCustom.identifier
)
