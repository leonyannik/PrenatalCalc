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
        let liquids = max(dv.naclhip_, dv.sol_fisiológica_)
        let potasium = max(max(dv.kcl_amp_10_,dv.kcl_amp_5_),dv.fosfato_k_)
        
        ps.weight = weight
        ps.líquidos_iv_tot = Double(round(100 * (weight * dv.líquidos)) / 100)
        ps.trophamine_10 = Double(round(100 * (weight * dv.prot_10 * 10)) / 100)
        ps.trophamine_8 = Double(round(100 * (weight * dv.prot_8 * 8)) / 100)
        ps.intralipid_20 = Double(round(100 * (weight * dv.lípidos * 5)) / 100)
        ps.sg_50 = Double(round(100 * (weight * dv.chs_50 * 1440 / 500)) / 100)
        ps.sg_10 = Double(round(100 * (weight * dv.chs_10 * 1440 / 100)) / 100)
        ps.kcl_amp_10 = Double(round(100 * (weight * dv.kcl_amp_10_ * 1 / 2)) / 100)
        ps.kcl_amp_5 = Double(round(100 * (weight * dv.kcl_amp_5_ * 1 / 4)) / 100)
        ps.naclhip = Double(round(100 * (weight * dv.naclhip_ * 1 / 3)) / 100)
        ps.sol_fisiológica = Double(round(100 * (weight * dv.sol_fisiológica_ * 100 / 15.4)) / 100)
        ps.fosfato_k = Double(round(100 * (weight * dv.fosfato_k_ / 1.102)) / 100)
        ps.glucca = Double(round(100 * (weight * dv.calcio_ / 100)) / 100)
        ps.magnesio = Double(round(100 * (weight * dv.magnesio_ / 100)) / 100)
        ps.mvi = (1.7 * weight) > 5 ? 5 : Double(round(100 * (1.7 * weight)) / 100)
        ps.oligoelementos = Double(round(100 * (dv.oligoelementos_ * weight)) / 100)
        ps.l_cisteína = (proteins * weight * 100 / 2.5) > 100 ? 100 : Double(round(100 * (proteins * weight * 100 / 2.5)) / 100)
        ps.carnitina = Double(round(100 * (dv.carnitina_ * weight)) / 100)
        if Int(patient!.weeks!)! >= 32 {
            ps.heparina = 0
        }else {
            ps.heparina = dv.heparina_ * ps.intralipid_20
        }
        let sum = Double(round(100 * (ps.oligoelementos + ps.mvi + ps.magnesio + ps.glucca + ps.fosfato_k + ps.naclhip + ps.sol_fisiológica + ps.trophamine_10 + ps.trophamine_8 + ps.sg_50 + ps.sg_10 + ps.kcl_amp_10 + ps.kcl_amp_5 + ps.intralipid_20)) / 100)
        ps.abd = ps.líquidos_iv_tot - sum
        ps.líquidos_tot = ps.líquidos_iv_tot
        ps.calorías_tot = (carbs * 3.4) + (dv.lípidos * 10) + (proteins * 4)
        ps.caljjml = Double(round(100 * (ps.calorías_tot / ps.líquidos_tot)) / 100)
        ps.caljjkgjjdia = Double(round(100 * (ps.calorías_tot / weight)) / 100)
        ps.infusión = Double(round(100 * (ps.líquidos_tot / 24)) / 100)
        ps.nitrógeno = Double(round(100 * (proteins * weight / 6.5)) / 100)
        ps.relcnpjntg = (carbs * 3.4) + (dv.lípidos * 10)
        ps.concentración = 0//TODO: Falta concentración
        ps.gkm = Double(round(100 * (carbs * 1000 / 1440)) / 100)
        ps.calprot = Double(round(100 * ((proteins * 4 * 100) / ps.calorías_tot)) / 100)
        ps.calgrasa = Double(round(100 * ((dv.lípidos * 10 * 100) / ps.calorías_tot)) / 100)
        ps.calchs50 = Double(round(100 * ((dv.chs_50 * 3.4 * 100) / ps.calorías_tot)) / 100)
        ps.calchs10 = Double(round(100 * ((dv.chs_10 * 3.4 * 100) / ps.calorías_tot)) / 100)
        
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
        
        noPreviousCalculationsLabel.isHidden = solutions.count > 0 ? true : false
        tableView.reloadData()
        collectionView.reloadData()
        if ps.abd < 0 {
            print("Se pasa")
            let alert = UIAlertController(title: "Atención", message: "Al calcular con CHS 10%, se excede el valor de líquidos intravenosos totales permitidos por: \(-ps.abd) ml, por favor, calcule usando CHS 50%", preferredStyle: .alert)
            let recalculate = UIAlertAction(title: "Corregir", style: .cancel) { (action) in
                DispatchQueue.main.async {
                    self.editButtonTapped(self)
                }
            }
            let ignore = UIAlertAction(title: "Ignorar", style: .default, handler: nil)
            alert.addAction(recalculate)
            alert.addAction(ignore)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("Presenté la alerta")
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
            if [10,11,12,13].contains(indexPath.row) {
                key = "% " + key
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
        cell.nameLabel.text = key.uppercased().replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "JJ", with: "/").replacingOccurrences(of: "J", with: "-")
        cell.valueLabel.text = value + " \(unityDictionary[key.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: "")]!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        cell.weightLabel.text = String(solutions[indexPath.row].weight)
        if indexPath.row == selectedSolutionIndex {
            cell.isSelectedView.layer.cornerRadius = 9
            cell.isSelectedView.layer.borderColor = UIColor.darkGray.cgColor
            cell.isSelectedView.layer.borderWidth = 2
        }else {
            cell.isSelectedView.layer.borderWidth = 0
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
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension PresentDataViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 140, height: 80)
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



