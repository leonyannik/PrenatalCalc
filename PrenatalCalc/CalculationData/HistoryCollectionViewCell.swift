//
//  HistoryCollectionViewCell.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 9/1/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

protocol DeleteCalculationDelegate: class {
    func delete(index: Int)
}

class HistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var isSelectedView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: DeleteCalculationDelegate?
    var index = 0
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.delete(index: index)
    }
    
    override func prepareForReuse() {
        index = 0
    }
}
