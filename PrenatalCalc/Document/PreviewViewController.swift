//
//  PreviewViewController.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 8/26/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import MessageUI

class PreviewViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var printingView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameOfDocumentLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    var fileData = [String: String]()
    var patientValues = [String: Double]()
    var patientValuesindexes = [String]()
    var patientThings: Things!
    var patient: Patient?
    var solution: SolutionToUse?
    var note: String!
    var weight: Double!
    let gray = UIColor(red: 0.98, green: 0.98, blue: 0.976, alpha: 1)
    var colors = [UIColor(red: 1, green: 0.974, blue: 0.522, alpha: 1), UIColor(red: 0.806, green: 0.995, blue: 1, alpha: 1), UIColor(red: 0.776, green: 1, blue: 0.904, alpha: 1), UIColor(red: 1, green: 0.884, blue: 0.702, alpha: 1), UIColor(red: 0.98, green: 0.98, blue: 0.976, alpha: 1)]
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setZoomScale()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "DR. \(nameOfDoctor)"
        logoImageView.image = logo
        scrollView.delegate = self
        nameLabel.layer.cornerRadius = 4
        logoImageView.layer.cornerRadius = 4
        nameOfDocumentLabel.layer.cornerRadius = 4
        printingView.layer.borderColor = UIColor(red: 0.239, green: 0.494, blue: 0.706, alpha: 1).cgColor
        printingView.layer.borderWidth = 4
        printingView.layer.cornerRadius = 4
        composeDocument()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FunctionOutlets
    @IBAction func printButtonTapped(_ sender: Any) {
        prepareToPrint()
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "CálculoParenteral"
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = printingView.toImage()
        printController.present(from: printingView.bounds, in: printingView, animated: true, completionHandler: nil)
        colors = [UIColor(red: 1, green: 0.974, blue: 0.522, alpha: 1), UIColor(red: 0.806, green: 0.995, blue: 1, alpha: 1), UIColor(red: 0.776, green: 1, blue: 0.904, alpha: 1), UIColor(red: 1, green: 0.884, blue: 0.702, alpha: 1), gray]
        collectionView.reloadData()
    }
    @IBAction func composeMailButtonTapped(_ sender: Any) {
        prepareToPrint()
        if thisDevice.isSimulator() {
            print("se supone que debo imprimir")
        }else {
            generatePdfFromView(filename: "view") { (pdf) in
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setSubject("Cálculo Prenatal")
                composeVC.setMessageBody("Preparar la siguiente solución", isHTML: false)
                composeVC.addAttachmentData(pdf as Data, mimeType: "application/pdf", fileName: "orden de solución parenteral")
                self.present(composeVC, animated: true, completion: nil)
                colors = [UIColor(red: 1, green: 0.974, blue: 0.522, alpha: 1), UIColor(red: 0.806, green: 0.995, blue: 1, alpha: 1), UIColor(red: 0.776, green: 1, blue: 0.904, alpha: 1), UIColor(red: 1, green: 0.884, blue: 0.702, alpha: 1), gray]
                collectionView.reloadData()
            }
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    func prepareToPrint() {
        for (index, _) in colors.enumerated() {
            colors[index] = gray
        }
        collectionView.reloadData()
    }
    
    // MARK: - Functions
    func generatePdfFromView(filename:String, success:(NSMutableData) -> ()) {
        let pdfData = NSMutableData()
        let contentArea = CGRect(
            x: 0,
            y: 0,
            width: printingView.bounds.size.width,
            height: printingView.bounds.size.height
        )
        
        UIGraphicsBeginPDFContextToData(pdfData, contentArea, nil)
        UIGraphicsBeginPDFPage()
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        printingView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        success(pdfData)
    }
    
    func setZoomScale() {
        var minZoom = min(self.view.bounds.size.width / printingView.bounds.size.width, self.view.bounds.size.height / printingView.bounds.size.height);
        if (minZoom > 1.0) {
            minZoom = 1.0
        }
        scrollView.minimumZoomScale = minZoom;
        scrollView.zoomScale = minZoom;
    }
    
    func composeDocument() {
        fileData = ["paciente": patient!.name!, "fecha": LYDate.toStringDateNormal(date: Date(timeIntervalSince1970: solution!.fecha)), "expediente": patient!.file!,  "cama": patient!.bed!, "dx": patient!.dx!, "gestación": patient!.weeks!]
        let mirroredValues = Mirror(reflecting: solution!)
        for child in mirroredValues.children {
            if let value = child.value as? Double {
                patientValues[child.label!] =  value
            }
        }
        patientValues["gluccaMl"] = Double(round(100 * patientValues["glucca"]! / 0.464)  / 100)
        patientValues["magnesioMl"] = Double(round(100 * patientValues["magnesio"]! / 2.025 ) / 100)
    }
}

extension PreviewViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return printingView
    }
}


extension PreviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: (collectionView.frame.size.width / 2) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 26) - (collectionView.frame.size.width / 160))
        if indexPath.section == 1 {
            size = CGSize(width: (collectionView.frame.size.width / 3) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 22) - (collectionView.frame.size.width / 160))
        }else if indexPath.section == 2 {
            size = CGSize(width: (collectionView.frame.size.width / 3) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 22) - (collectionView.frame.size.width / 160))
        }else if indexPath.section == 3 {
            size = CGSize(width: (collectionView.frame.size.width / 4) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 26) - (collectionView.frame.size.width / 160))
        }else if indexPath.section == 4 {
            size = CGSize(width: collectionView.frame.size.width - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 8) - (collectionView.frame.size.width / 160))
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.size.width / 180
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.size.width / 180
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath) as! DocSubtitleCollectionReusableView
        switch indexPath.section {
        case 0:
            view.titleLabel.text = "Datos Generales"
        case 1:
            view.titleLabel.text = "Favor de preparar la siguiente solución:"
        case 2:
            view.titleLabel.text = "Datos de Referencia"
        case 3:
            view.titleLabel.text = "Información Adicional"
        default:
            view.titleLabel.text = "Notas:"
            view.asteriscLabel.text = asteriscInformation
        }
        return view
    }
}

extension PreviewViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return fileDataKeys.count
        case 1:
            return solutionValuesKeys.count
        case 2:
            return otherSolutionValuesKeys.count
        case 3:
            return aditionalInformationTable.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalCell", for: indexPath) as! ValueCollectionViewCell
            cell.layer.cornerRadius = 2
            let key = fileDataKeys[indexPath.row]
            cell.contentLabel.text = key.uppercased().replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "JJ", with: "/").replacingOccurrences(of: "J", with: "-").replacingOccurrences(of: "JJ", with: "/")
            cell.valueLabel.text = fileData[key]!
            cell.unitsLabel.text = ""
            cell.widthContraint.constant = (collectionView.frame.size.width / 4) * 1.2
            cell.backgroundColor = colors[0]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "valueCell", for: indexPath) as! ValueCollectionViewCell
            cell.layer.cornerRadius = 2
            let key = solutionValuesKeys[indexPath.row]
            cell.contentLabel.text = displayNames[key]!.uppercased() + ":"
            cell.valueLabel.text = String(patientValues[key]!)
            
            if displayNames[key]!.uppercased() == "MULTIVITAMÍNICO INTRAVENOSO" {
                if patientValues[key]! > 5 {
                    let value = String(patientValues[key]!) + " Máx: 5.0"
                    let attributeString =  NSMutableAttributedString(string: value)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, String(patientValues[key]!).count))
                    cell.valueLabel.attributedText = attributeString
                }
            }else if displayNames[key]!.uppercased() == "L-CISTEÍNA" {
                if patientValues[key]! > 100 * weight {
                    let value = String(patientValues[key]!) + " Máx: \(100 * weight)"
                    let attributeString =  NSMutableAttributedString(string: value)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, String(patientValues[key]!).count))
                    cell.valueLabel.attributedText = attributeString
                }
            }else {
                cell.valueLabel.text = String(patientValues[key]!)
            }
            
            
            
            
            cell.unitsLabel.text = units[key]
            cell.backgroundColor = colors[1]
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "valueCell", for: indexPath) as! ValueCollectionViewCell
            cell.layer.cornerRadius = 2
            let key = otherSolutionValuesKeys[indexPath.row]
            cell.contentLabel.text = displayNames[key]!.uppercased() + ":"
            cell.valueLabel.text = String(patientValues[key]!)
            cell.unitsLabel.text = units[key]
            cell.backgroundColor = colors[2]
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notesCell", for: indexPath) as! NotesCollectionViewCell
            cell.notesLabel.text = aditionalInformationTable[indexPath.row]
            cell.backgroundColor = colors[3]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notesCell", for: indexPath) as! NotesCollectionViewCell
            cell.layer.cornerRadius = 2
            cell.notesLabel.text = aditionalInformation + "\n " + note
            cell.backgroundColor = colors[4]
            return cell
        }
    }
}

extension PreviewViewController: UICollectionViewDelegate {
    
}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
