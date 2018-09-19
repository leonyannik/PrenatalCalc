//
//  SettingsViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 8/27/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var changeLogoButton: UIButton!
    @IBOutlet weak var deleteDataButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var patient: Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        changeLogoButton.layer.cornerRadius = 9
        logoImageView.layer.cornerRadius = 9
        if let name = defaults.string(forKey: "name") {
            nameTextField.text = name
        }
        let path = URL.urlInDocumentsDirectory(with: "defaultLogo").path
        let image = UIImage(contentsOfFile: path)
        if let defaultImage = image {
             self.logoImageView.image = defaultImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -Navigation:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditDefaultValues" {
            let controller = segue.destination as! EditValuesViewController
            controller.patient = patient
            controller.editingDefault = true
        }
    }
    
    @IBAction func changeLogoButtonTapped(_ sender: Any) {
        present(self.imagePicker, animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        nameOfDoctor = nameTextField.text!
        defaults.set(nameOfDoctor, forKey: "name")
        logo = logoImageView.image!
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteDataButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Advertencia", message: "¿Está seguro que desea borrar todos los registros?, esta acción no puede deshacerse", preferredStyle: .alert)
        let action = UIAlertAction(title: "ELIMINAR", style: .destructive) { action in
            let patientDeleteRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: patientDeleteRequest as! NSFetchRequest<NSFetchRequestResult>)
            try! moc.persistentStoreCoordinator?.execute(deleteRequest, with: moc)
            try! moc.save()
            self.logoImageView.image = UIImage(named: "placeHolder")
            self.saveTheImage(image: UIImage(named: "placeHolder")!)
            defaults.removeObject(forKey: "name")
            self.nameTextField.text = ""
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let patientRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
        patientRequest.predicate = NSPredicate(format: "%K == %@", entity.name, "prenatalDefault")
        moc.perform {
            do {
                let fetchedPatients = try patientRequest.execute()
                if fetchedPatients.count > 0 {
                    self.patient = fetchedPatients.first!
                    self.performSegue(withIdentifier: "toEditDefaultValues", sender: nil)
                }
            }catch {
                print("Error on read persistance: \(error)")
            }
        }
    }
}

//MARK: Extension ImagePickerControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { print("there was no edited image");dismiss(animated: true, completion: nil);return}
        self.logoImageView.image = editedImage
        saveTheImage(image: editedImage)
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func saveTheImage(image: UIImage) {
        let path = URL.urlInDocumentsDirectory(with: "defaultLogo")
        try! UIImagePNGRepresentation(image)?.write(to: path)
    }
}

extension SettingsViewController: UINavigationControllerDelegate {
    
}

extension URL {
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: documentsDirectory)
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}
