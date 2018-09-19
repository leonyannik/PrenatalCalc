//
//  NewPacientViewController.swift
//  PrenatalCalc
//
//  Created by Developer on 8/20/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

class NewPacientViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Añadir Paciente"
        nextButton.layer.cornerRadius = 9
        cancelButton.layer.cornerRadius = 9
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! PatientDetailsViewController
        controller.name = nameTextField.text
        controller.weight = weightTextField.text
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if (self.nameTextField.text != "" && self.weightTextField.text != "") {
            performSegue(withIdentifier: "toDetailsSegue", sender: nil)
        }else {
            let alert = UIAlertController(title: "Espera!", message: "Debes llenar todos los campos", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
