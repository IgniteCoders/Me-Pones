//
//  UIImageViewExtension.swift
//  Me Pones
//
//  Created by Mañanas on 19/9/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(url: URL) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadFrom(url: String) {
        self.loadFrom(url: URL(string: url)!)
    }
    
    func loadFrom(url: String, completionHandler: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completionHandler(image)
                    }
                }
            }
        }
    }
}
