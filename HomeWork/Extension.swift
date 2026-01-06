//
//  Extension.swift
//  HomeWork
//
//  Created by VP on 06.01.2026.
//

import UIKit

extension UIImageView {
    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
