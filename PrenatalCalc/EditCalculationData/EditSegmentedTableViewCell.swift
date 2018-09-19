//
//  EditSegmentedTableViewCell.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 9/2/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

protocol SegmentSelectionDelegate {
    func titleChanged(index: Int, title: String)
}

class EditSegmentedTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameSegmentedControl: UISegmentedControl!
    
    var delegate: SegmentSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func nameSegmentedControlChanged(_ sender: Any) {
        let index = nameSegmentedControl.selectedSegmentIndex
        delegate?.titleChanged(index: index, title: nameSegmentedControl.titleForSegment(at: index)!)
    }
    

}
