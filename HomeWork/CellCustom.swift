//
//  CellCustom.swift
//  HomeWork
//
//  Created by VP on 09.01.2026.
//

import UIKit

class CellCustom: UITableViewCell {
    
    static let identifier = "CellCustom"
   
    var imageCell: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var titleCell: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint() {
        contentView.frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        contentView.addSubview(imageCell)
        contentView.addSubview(titleCell)
        imageCell.frame = contentView.bounds
    }
    
    func setData(frome model: UnsplashModel) {
    }
    
}
