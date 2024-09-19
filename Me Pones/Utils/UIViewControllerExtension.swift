//
//  UIViewControllerExtension.swift
//  Me Pones
//
//  Created by Mañanas on 19/9/24.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showToast(message : String, seconds: Double = 2){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
