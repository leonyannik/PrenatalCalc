//
//  NotesViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 9/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var textViewPlaceHolder = ""
    var noteToPass = ""
    var patient: Patient?
    var weight: Double!
    var solution: SolutionToUse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.layer.cornerRadius = 5.0
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! PreviewViewController
        controller.note = noteToPass
        controller.patient = patient
        controller.solution = solution
        controller.weight = weight
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        if textView.textColor == .lightGray {
            noteToPass = ""
        }else {
            noteToPass = textView.text!
        }
        performSegue(withIdentifier: "toPreviewSegue", sender: nil)
    }
 
}
//MARK: - Extensions
extension NotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
