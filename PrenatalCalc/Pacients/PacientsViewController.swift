//
//  PacientsViewController.swift
//  PrenatalCalc
//
//  Created by Developer on 8/20/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

class PacientsViewController: UIViewController {

    @IBOutlet weak var addNewPacientButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var index = 0
    var patients = [Patient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nutrición Parenteral"
        addNewPacientButton.layer.cornerRadius = 9
        tableView.tableFooterView = UIView()
        tableView.contentInset.bottom = 65
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readPatientsFromPersistance {
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDataSegue" {
            let controller = segue.destination as! PresentDataViewController
            controller.patient = patients[index]
        }else if segue.identifier == "toEditValuesSegue" {
            let controller = segue.destination as! EditValuesViewController
            controller.patient = patients[index]
        }
    }
    

    @IBAction func addNewPacientButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAddPacient", sender: nil)
    }
    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsSegue", sender: nil)
    }
    
    
    func readPatientsFromPersistance(done: @escaping () -> Swift.Void) {
        let patientRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
        patientRequest.predicate = NSPredicate(format: "%K != %@", entity.name, "prenatalDefault")
        moc.perform {
            do {
                let fetchedPatients = try patientRequest.execute()
                self.patients = fetchedPatients
                done()
            }catch {
                print("Error on read persistance: \(error)")
            }
        }
    }
    
    
    
}

extension PacientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pacientCell") as! PacientTableViewCell
        let patient = patients[indexPath.row]
        cell.nameLabel.text = patient.name
        if let date = patient.lastDate as? Date {
            cell.dateLabel.text = LYDate.toStringDateNormal(date: date)
        }else {
            cell.dateLabel.text = "vacío"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension PacientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toDataSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar") {action, index in
            let patientDeleteRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
            patientDeleteRequest.predicate = NSPredicate(format: "%K == %@", entity.id, self.patients[indexPath.row].id!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: patientDeleteRequest as! NSFetchRequest<NSFetchRequestResult>)
            try! moc.persistentStoreCoordinator?.execute(deleteRequest, with: moc)
            try! moc.save()
            self.patients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar valores") { action, index in
            self.index = indexPath.row
            self.performSegue(withIdentifier: "toEditValuesSegue", sender: nil)
        }
        editAction.backgroundColor = UIColor.blue
        return [deleteAction, editAction]
    }
}












