//
//  ChangeConstantViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 7/18/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

protocol SendConstantValueProtocol {
    func valueChanged(value: Double)
}

class ChangeConstantViewController: UIViewController {

    
    @IBOutlet weak var inputField: UITextField!
    
    var value: String?
    var delegate: SendConstantValueProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.text = value
        inputField.becomeFirstResponder()
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 50)
        let doneToolbar: UIToolbar = UIToolbar(frame: frame)
        doneToolbar.barStyle = .blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: .doneButton)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputField.inputAccessoryView = doneToolbar
        // Do any additional setup after loading the view.
    }

    @objc func doneButtonAction()
    {
        inputField.resignFirstResponder()
        dismiss(animated: true) {
            var number: Double = 0
            if self.inputField.text != "" {
                number = Double(self.inputField.text!)!
                self.delegate?.valueChanged(value: number)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension Selector {
    static let doneButton = #selector(ChangeConstantViewController.doneButtonAction)
}
