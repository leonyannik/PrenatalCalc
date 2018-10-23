//
//  EditValuesViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 7/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit


protocol EditSolutionDelegate {
    func doneEditing(things: ProvidedSolutionValues)
}

class EditValuesViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var valueToSend = ""
    var patient: Patient?
    var patientValues = [String: Double]()
    var keyBeingEdited = ""
    var patientThings: Things!
    var editingDefault = false
    var editingSolution = false
    var delegate: EditSolutionDelegate?
    var values: ProvidedSolutionValues!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 9
        cancelButton.layer.cornerRadius = 9
        if !editingSolution {
            patientThings = try! jsonDecoder.decode(Things.self, from: patient!.things as! Data)
            let mirroredValues = Mirror(reflecting: patientThings.patientValues)
            for child in mirroredValues.children {
                if let value = child.value as? Double {
                    patientValues[child.label!] =  value
                }
            }
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ChangeConstantViewController
        controller.delegate = self
        controller.value = valueToSend
    }

    @IBAction func saveNewValues(_ sender: Any) {
        if editingSolution {
            delegate?.doneEditing(things: values)
            let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.leave), userInfo: nil, repeats: false)
        }else {
            let thingsToSave = try! jsonEncoder.encode(patientThings)
            patient?.things = thingsToSave as! NSData
            try! moc.save()
            if editingDefault {
                solutionValuesDefault = patientThings.patientValues
            }
            let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.leave), userInfo: nil, repeats: false)
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        leave()
    }
    
    @objc func leave() {
        dismiss(animated: false, completion: nil)
        navigationController?.popViewController(animated: false)
    }
    
}

extension EditValuesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providedValuesKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "constantsCell") as! EditValueTableViewCell
        let key = providedValuesKeys[indexPath.row]
        let item = patientValues[key]
        cell.nameLabel.text = displayNames[key]!.uppercased()
        if item != nil {
            cell.valueLabel.text = String(item!)
        }
        return cell
    }
}

extension EditValuesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditValueTableViewCell
        valueToSend = cell.valueLabel.text!
        keyBeingEdited = providedValuesKeys[indexPath.row]
        performSegue(withIdentifier: "toChangeConstant", sender: nil)
    }
}

extension EditValuesViewController: SendConstantValueProtocol {
    func valueChanged(value: Double) {
        if editingSolution {
            if ["prot_10", "prot_8"].contains(keyBeingEdited) {
                values.changeProperty(name: "prot_10", value: 0)
                values.changeProperty(name: "prot_8", value: 0)
                patientValues["prot_10"] =  0
                patientValues["prot_8"] =  0
            }else if ["chs_50", "chs_10"].contains(keyBeingEdited) {
                values.changeProperty(name: "chs_50", value: 0)
                values.changeProperty(name: "chs_10", value: 0)
                patientValues["chs_50"] =  0
                patientValues["chs_10"] =  0
            }else if ["naclhip_", "sol_fisiológica_"].contains(keyBeingEdited) {
                values.changeProperty(name: "naclhip_", value: 0)
                values.changeProperty(name: "sol_fisiológica_", value: 0)
                patientValues["naclhip_"] =  0
                patientValues["sol_fisiológica_"] =  0
            }
            values.changeProperty(name: keyBeingEdited, value: value)
        }else {
            if ["prot_10", "prot_8"].contains(keyBeingEdited) {
                patientThings.patientValues.changeProperty(name: "prot_10", value: 0)
                patientThings.patientValues.changeProperty(name: "prot_8", value: 0)
                patientValues["prot_10"] =  0
                patientValues["prot_8"] =  0
            }else if ["chs_50", "chs_10"].contains(keyBeingEdited) {
                patientThings.patientValues.changeProperty(name: "chs_50", value: 0)
                patientThings.patientValues.changeProperty(name: "chs_10", value: 0)
                patientValues["chs_50"] =  0
                patientValues["chs_10"] =  0
            }else if ["naclhip_", "sol_fisiológica_"].contains(keyBeingEdited) {
                patientThings.patientValues.changeProperty(name: "naclhip_", value: 0)
                patientThings.patientValues.changeProperty(name: "sol_fisiológica_", value: 0)
                patientValues["naclhip_"] =  0
                patientValues["sol_fisiológica_"] =  0
            }
            patientThings.patientValues.changeProperty(name: keyBeingEdited, value: value)
        }
        patientValues[keyBeingEdited] =  value
        tableView.reloadData()
    }

}

extension EditValuesViewController: SegmentSelectionDelegate {
    func titleChanged(index: Int, title: String) {
        print(index, " ", title)
    }
}
