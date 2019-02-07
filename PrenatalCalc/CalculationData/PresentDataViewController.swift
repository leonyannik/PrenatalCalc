//
//  ViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 7/7/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import MessageUI

class PresentDataViewController: UIViewController {
    
    @IBOutlet weak var createReportButton: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var noPreviousCalculationsLabel: UILabel!
    
    var patient: Patient?
    var solutions = [SolutionToUse]()
    var solutionValues = [String: Double]()
    var solutionValuesToBeEdited = [String: Double]()
    var patientThings: Things!
    var valuesToEdit =  ProvidedSolutionValues()
    var selectedSolutionIndex = 0
    var expanded = [true, true, true]
                   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nutrición Parenteral"
        createReportButton.layer.cornerRadius = 9
        calculateButton.layer.cornerRadius = 9
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 60
        weightLabel.text = String(patient!.lastWeight) + " Kg"
        patientThings = try! jsonDecoder.decode(Things.self, from: patient!.things as! Data)
        solutions = patientThings.solution
        noPreviousCalculationsLabel.isHidden = solutions.count > 0 ? true : false
        if solutions.count > 0 {
            let mirroredValues = Mirror(reflecting: solutions.first!)
            for child in mirroredValues.children {
                if let value = child.value as? Double {
                    solutionValues[child.label!] =  value
                }
            }
            solutionValues["gluccaMl"] = Double(round(100 * solutionValues["glucca"]! / 0.464) / 100)
            solutionValues["magnesioMl"] = Double(round(100 * solutionValues["magnesio"]! / 2.025 ) / 100)
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChangeWeightSegue" {
            let controller = segue.destination as! ChangeConstantViewController
            controller.delegate = self
            controller.value = String(patient!.lastWeight)
        }else if segue.identifier == "toEditValuesSegue" {
            let controller = segue.destination as! EditValuesViewController
            controller.editingSolution = true
            controller.delegate = self
            controller.values = valuesToEdit
            controller.patientValues = solutionValuesToBeEdited
        }else if segue.identifier == "toPreviewSegue" {
            let controller = segue.destination as! PreviewViewController
            controller.patient = patient
            controller.solution = solutions[selectedSolutionIndex]
        }else if segue.identifier == "toNoteSegue" {
            let controller = segue.destination as! NotesViewController
            controller.patient = patient
            controller.weight = solutions[selectedSolutionIndex].weight
            controller.solution = solutions[selectedSolutionIndex]
        }
    }
    
    @IBAction func createReportButtonTapped(_ sender: Any) {
        if solutions.count > 0 {
            performSegue(withIdentifier: "toNoteSegue", sender: nil)
        }else {
            let alert = UIAlertController(title: "Aguarde", message: "Debe tener algún cálculo para generar un reporte", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { action in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func weightButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toChangeWeightSegue", sender: nil)
        
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        calculateValues(defaultValues: patientThings.patientValues, new: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if solutions.count > 0 {
            let values = solutions[selectedSolutionIndex]
            valuesToEdit.líquidos = values.líquidos
            valuesToEdit.sol_fisiológica_ = values.sol_fisiológica_
            valuesToEdit.prot_10 = values.prot_10
            valuesToEdit.prot_8 = values.prot_8
            valuesToEdit.chs_50 = values.chs_50
            valuesToEdit.chs_10 = values.chs_10
            valuesToEdit.kcl_amp_10_ = values.kcl_amp_10_
            valuesToEdit.kcl_amp_5_ = values.kcl_amp_5_
            valuesToEdit.naclhip_ = values.naclhip_
            valuesToEdit.lípidos = values.lípidos
            valuesToEdit.fosfato_k_ = values.fosfato_k_
            valuesToEdit.calcio_ = values.calcio_
            valuesToEdit.magnesio_ = values.magnesio_
            valuesToEdit.mvi_ = values.mvi_
            valuesToEdit.oligoelementos_ = values.oligoelementos_
            valuesToEdit.carnitina_ = values.carnitina_
            valuesToEdit.heparina_ = values.heparina_
            let mirroredValues = Mirror(reflecting: valuesToEdit)
            for child in mirroredValues.children {
                if let value = child.value as? Double {
                    solutionValuesToBeEdited[child.label!] =  value
                }
            }
            performSegue(withIdentifier: "toEditValuesSegue", sender: nil)
        }else {
            let alert = UIAlertController(title: "Aguarde", message: "Debe tener algún cálculo para poder editarlo", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { action in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func calculateValues(defaultValues: ProvidedSolutionValues, new: Bool) {
        let patientDefaultValues = try! jsonEncoder.encode(defaultValues)
        let dv = defaultValues
        var ps = try! jsonDecoder.decode(Solution.self, from: patientDefaultValues)
        ps.fecha = Date().timeIntervalSince1970
        patient?.lastDate =  Date(timeIntervalSince1970: ps.fecha) as NSDate
        let weight = (patient?.lastWeight)!
        
        let proteins = max(dv.prot_10, dv.prot_8)
        let carbs = max(dv.chs_50, dv.chs_10)
        
        ps.weight = weight
        ps.líquidos_iv_tot = Double(round(100 * (weight * dv.líquidos)) / 100)
        ps.trophamine_10 = Double(round(100 * (weight * dv.prot_10 / 0.1)) / 100)
        ps.trophamine_8 = Double(round(100 * (weight * dv.prot_8 / 0.08)) / 100)
        ps.intralipid_20 = Double(round(100 * (weight * dv.lípidos * 5)) / 100)
        ps.sg_50 = Double(round(100 * (weight * dv.chs_50 * 100 / 50)) / 100)
        ps.sg_10 = Double(round(100 * (weight * dv.chs_10 * 100 / 10)) / 100)
        ps.kcl_amp_10 = Double(round(100 * (weight * dv.kcl_amp_10_ / 2)) / 100)
        ps.kcl_amp_5 = Double(round(100 * (weight * dv.kcl_amp_5_ / 4)) / 100)
        ps.naclhip = Double(round(100 * (weight * dv.naclhip_ / 3)) / 100)
        ps.sol_fisiológica = Double(round(100 * (weight * dv.sol_fisiológica_ * 100 / 15.4)) / 100)
        ps.fosfato_k = Double(round(100 * (weight * dv.fosfato_k_ / 1.102)) / 100)
//        ps.glucca = Double(round(100 * (weight * dv.calcio_ / 100) * 0.464) / 100)
//        ps.magnesio = Double(round(100 * (weight * dv.magnesio_ / 100) * 0.81) / 40)
        ps.glucca = Double(round(100 * (weight * dv.calcio_ / 100) * 0.464) / 100)
        ps.magnesio = Double(round(100 * (weight * dv.magnesio_ / 100) * 0.81) / 100)
        ps.mvi = Double(round(100 * (1.7 * weight)) / 100)
        ps.oligoelementos = Double(round(100 * (dv.oligoelementos_ * weight)) / 100)
        ps.l_cisteína = Double(round(100 * (proteins * weight * 100 / 2.5)) / 100)
        ps.carnitina = Double(round(100 * (dv.carnitina_ * weight)) / 100)
        ps.heparina = Double(round(100 * (dv.heparina_ * ps.intralipid_20)) / 100)
        let sum = Double(round(100 * (ps.oligoelementos + ps.mvi + ps.magnesio + ps.glucca + ps.fosfato_k + ps.naclhip + ps.sol_fisiológica + ps.trophamine_10 + ps.trophamine_8 + ps.sg_50 + ps.sg_10 + ps.kcl_amp_10 + ps.kcl_amp_5 + ps.intralipid_20)) / 100)
        ps.abd = Double(round(100 * (ps.líquidos_iv_tot - sum)) / 100)
        ps.líquidos_tot = ps.líquidos_iv_tot
        ps.calorías_tot = Double(round(100 * ((carbs * 3.4 * weight) + (dv.lípidos * 10 * weight) + (proteins * 4 * weight))) / 100) // es por 10 no por 11
        ps.caljjml = Double(round(100 * (ps.calorías_tot / ps.líquidos_tot)) / 100)
        ps.caljjkgjjdia = Double(round(100 * (ps.calorías_tot / weight)) / 100)
        ps.infusión = Double(round(100 * (ps.líquidos_tot / 24)) / 100)
        ps.nitrógeno = Double(round(100 * (proteins * weight / 6.25)) / 100)
        ps.relcnpjntg = Double(round(100 * (((carbs * 3.4 * weight) + (dv.lípidos * 10 * weight)) / ps.nitrógeno)) / 100)
        ps.concentración = Double(round(100 * (carbs * weight / ps.líquidos_tot * 100)) / 100)
        ps.gkm = Double(round(100 * (carbs * 1000 / 1440)) / 100)
        ps.calprot = Double(round(100 * ((proteins * 4 * weight * 100) / ps.calorías_tot)) / 100)
        ps.calgrasa = Double(round(100 * ((dv.lípidos * 10 * 100 * weight) / ps.calorías_tot)) / 100)
        ps.calchs50 = Double(round(100 * ((dv.chs_50 * 3.4 * weight * 100) / ps.calorías_tot)) / 100)
        ps.calchs10 = Double(round(100 * ((dv.chs_10 * 3.4 * weight * 100) / ps.calorías_tot)) / 100)
        
        let solution = try! jsonEncoder.encode(ps)
        let solutionToSave = try! jsonDecoder.decode(SolutionToUse.self, from: solution)
        
        if new {
            patientThings.solution.insert(solutionToSave, at: 0)
            solutions.insert(solutionToSave, at: 0)
            selectedSolutionIndex = 0
        }else {
            patientThings.solution[selectedSolutionIndex] = solutionToSave
            solutions[selectedSolutionIndex] = solutionToSave
        }
        let thingsToSave = try! jsonEncoder.encode(patientThings)
        patient?.things = thingsToSave as NSData
        try! moc.save()
        
        let mirroredValues = Mirror(reflecting: solutions[selectedSolutionIndex])
        for child in mirroredValues.children {
            if let value = child.value as? Double {
                solutionValues[child.label!] =  value
            }
        }
        solutionValues["gluccaMl"] = Double(round(100 * solutionValues["glucca"]! / 0.464) / 100)
        solutionValues["magnesioMl"] = Double(round(100 * solutionValues["magnesio"]! / 2.025 ) / 100)
        noPreviousCalculationsLabel.isHidden = solutions.count > 0 ? true : false
        tableView.reloadData()
        collectionView.reloadData()
        if ps.abd < 0 {
            let alert = UIAlertController(title: "Atención", message: "Al calcular con CHS 10%, se excede el valor de líquidos intravenosos totales permitidos por: \(-ps.abd) ml, por favor, calcule usando CHS 50%", preferredStyle: .alert)
            let recalculate = UIAlertAction(title: "Corregir", style: .cancel) { (action) in
                DispatchQueue.main.async {
                    self.editButtonTapped(self)
                }
            }
            let ignore = UIAlertAction(title: "Ignorar", style: .default, handler: nil)
            alert.addAction(recalculate)
            alert.addAction(ignore)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(alert, animated: true, completion: nil)
            }
        }
        if ps.l_cisteína > 100 * weight || ps.mvi > 5 {
            var message = ""
            if ps.l_cisteína > 100 * weight {
                message += "El valor de L-Cisteína excede 100 miligramos por kilo: \(ps.l_cisteína) mg"
            }
            if ps.mvi > 5 {
                message += message.count > 0 ? ", El valor de MVI excede 5 mililitros: \(ps.mvi) mg" : "El valor de MVI excede 5 mililitros: \(ps.mvi) mg"
            }
            let alert = UIAlertController(title: "Atención", message: "\(message) ¿quiere corregir?", preferredStyle: .alert)
            let recalculate = UIAlertAction(title: "Corregir", style: .cancel) { (action) in
                DispatchQueue.main.async {
                    self.editButtonTapped(self)
                }
            }
            let ignore = UIAlertAction(title: "Ignorar", style: .default, handler: nil)
            alert.addAction(recalculate)
            alert.addAction(ignore)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


extension PresentDataViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if solutions.count == 0 {
            return 0
        }
        switch section {
        case 2:
            return expanded[2] ? providedValuesKeys.count : 0
        case 0:
            return expanded[0] ? solutionValuesKeys.count : 0
        default:
            return expanded[1] ? otherSolutionValuesKeys.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return "Referencia por Médico:"
        case 0:
            return "Solución:"
        default:
            return "Datos Adicionales:"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        cell.delegate = self
        cell.section = section
        if solutions.count == 0 {
            cell.expandColapseButton.isHidden = true
        }else {
            cell.expandColapseButton.isHidden = false
        }
        if expanded[section] {
            cell.expandColapseButton.setTitle("Colapsar", for: .normal)
        }else {
            cell.expandColapseButton.setTitle("Expandir", for: .normal)
        }
        switch section {
        case 2:
            cell.titleLabel.text = "Referencia por Médico:"
        case 0:
            cell.titleLabel.text = "Solución:"
        default:
            cell.titleLabel.text = "Datos Adicionales:"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var key = ""
        var value = ""
        switch indexPath.section {
        case 2:
            key = providedValuesKeys[indexPath.row]
            value = key == "fecha" ? LYDate.toStringDateWithTime(date: Date(timeIntervalSince1970: solutionValues[key]!)) : String(solutionValues[key]!)
        case 0:
            key = solutionValuesKeys[indexPath.row]
            if solutionValues[key] != nil {
                value = String(solutionValues[key]!)
            }
        default:
            key = otherSolutionValuesKeys[indexPath.row]
            value = String(solutionValues[key]!)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
        cell.nameLabel.text = displayNames[key]!.uppercased()
        cell.valueLabel.text = value + " \(units[key.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: "")]!)"
        cell.exedentLabel.text = ""
        if displayNames[key]!.uppercased() == "MULTIVITAMÍNICO INTRAVENOSO" {
            if solutionValues[key]! > 5 {
                cell.valueLabel.text = "Máx: 5.0" + " \(units[key.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: "")]!)"
                cell.exedentLabel.text = value + " \(units[key.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: "")]!)"
            }
        }
        if displayNames[key]!.uppercased() == "L-CISTEÍNA" {
            if solutionValues[key]! > 100 * solutions[selectedSolutionIndex].weight {
                cell.valueLabel.text = "Máx: \(100 * solutions[selectedSolutionIndex].weight)" + " \(units[key.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: "")]!)"
                cell.exedentLabel.text = value + " \(units[key.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: "")]!)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension PresentDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PresentDataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionViewCell
        cell.dateLabel.text = LYDate.toStringDateNormal(date: Date(timeIntervalSince1970: solutions[indexPath.row].fecha))
        cell.weightLabel.text = String(solutions[indexPath.row].weight) + " Kg"
        cell.index = indexPath.row
        cell.delegate = self
        if indexPath.row == selectedSolutionIndex {
            cell.isSelectedView.layer.cornerRadius = 9
            cell.isSelectedView.layer.borderColor = UIColor.darkGray.cgColor
            cell.isSelectedView.layer.borderWidth = 2
        }else {
            cell.isSelectedView.layer.cornerRadius = 9
            cell.isSelectedView.layer.borderColor = UIColor.lightGray.cgColor
            cell.isSelectedView.layer.borderWidth = 0.5
        }
        return cell
        
    }
}

extension PresentDataViewController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mirroredValues = Mirror(reflecting: solutions[indexPath.row])
        for child in mirroredValues.children {
            if let value = child.value as? Double {
                solutionValues[child.label!] =  value
            }
        }
        selectedSolutionIndex = indexPath.row
        solutionValues["gluccaMl"] = Double(round(100 * solutionValues["glucca"]! / 0.464) / 100)
        solutionValues["magnesioMl"] = Double(round(100 * solutionValues["magnesio"]! / 2.025 ) / 100)
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension PresentDataViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 170, height: 80)
        return size
    }
}

extension PresentDataViewController: SendConstantValueProtocol {
    func valueChanged(value: Double) {
        patient?.lastWeight = value
        weightLabel.text = String(value) + " Kg"
        do {
            try moc.save()
        }catch {
            print("This is the error when trying to save the new weight: \(error)")
        }
    }
}

extension PresentDataViewController: ExpandColapseDelegate {
    func toogle(section: Int) {
        expanded[section] = !expanded[section]
        tableView.reloadData()
    }
}

extension PresentDataViewController: EditSolutionDelegate {
    func doneEditing(things: ProvidedSolutionValues) {
        calculateValues(defaultValues: things, new: false)
        print("estoy editando la solución")
    }
}

extension PresentDataViewController: DeleteCalculationDelegate {
    func delete(index: Int) {
        let alert = UIAlertController(title: "", message: "Seguro que deseas borrar éste cálculo?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Borrar", style: .destructive) { [weak self] (action) in
            self?.solutions.remove(at: index)
            self?.collectionView.performBatchUpdates({
                self?.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }, completion: { (ready) in
                self?.collectionView.reloadData()
            })
            self?.noPreviousCalculationsLabel.isHidden = self?.solutions.count ?? 0 > 0 ? true : false
            self?.patientThings.solution.remove(at: index)
            let thingsToSave = try! jsonEncoder.encode(self?.patientThings)
            self?.patient?.things = thingsToSave as NSData
            try! moc.save()
            if self?.solutions.count ?? 0 > 0 {
                let mirroredValues = Mirror(reflecting: self?.solutions.first!)
                for child in mirroredValues.children {
                    if let value = child.value as? Double {
                        self?.solutionValues[child.label!] =  value
                    }
                }
                self!.solutionValues["gluccaMl"] = Double(round(100 * self!.solutionValues["glucca"]! / 0.464) / 100)
                self!.solutionValues["magnesioMl"] = Double(round(100 * self!.solutionValues["magnesio"]! / 2.025 ) / 100)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
}



