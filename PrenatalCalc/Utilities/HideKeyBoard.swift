//
//  HideKeyBoard.swift
//  Cellersice2
//
//  Created by Leon Yannik Lopez Rojas on 4/19/17.
//  Copyright © 2017 Inclan. All rights reserved.
//

import UIKit
import Foundation


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}
