//
//  PatientDetailsViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 9/10/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

class PatientDetailsViewController: UIViewController {

    @IBOutlet weak var fileTextField: UITextField!
    @IBOutlet weak var bedTextField: UITextField!
    @IBOutlet weak var diagnosticTextField: UITextField!
    @IBOutlet weak var gestationWeeks: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var name: String!
    var weight: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Otra información"
        saveButton.layer.cornerRadius = 9
        cancelButton.layer.cornerRadius = 9
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if (self.fileTextField.text != "" && self.bedTextField.text != "" && self.diagnosticTextField.text != "" && self.gestationWeeks.text != "") {
            do {
                let defaultValues = try jsonEncoder.encode(solutionValuesDefault) // Create the default values
                let patientValues = try jsonDecoder.decode(ProvidedSolutionValues.self, from: defaultValues) //create a provitional solution with the default values
                let things = Things(patientValues: patientValues, solution: [])
                let thingsToSave = try jsonEncoder.encode(things) // create json Data of the provitional solution
                guard let newPatient = NSEntityDescription.insertNewObject(forEntityName: entity.patient, into: moc) as? Patient else {return}
                newPatient.id = UUID().uuidString
                newPatient.lastWeight = Double(weight)!
                newPatient.name = name
                newPatient.file = self.fileTextField.text!
                newPatient.bed = self.bedTextField.text!
                newPatient.dx = self.diagnosticTextField.text!
                newPatient.weeks = self.gestationWeeks.text!
                newPatient.things = thingsToSave as NSData
                try moc.save()
            }
            catch {
                print("Error on saving: \(error)")
            }
            navigationController?.popToViewController((navigationController?.viewControllers.first)!, animated: true)
        }else {
            let alert = UIAlertController(title: "Espera!", message: "Debes llenar todos los campos", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
