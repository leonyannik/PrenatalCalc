//
//  MenuTableViewCell.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 9/9/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

protocol ExpandColapseDelegate {
    func toogle(section: Int)
}

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandColapseButton: UIButton!
    
    var delegate: ExpandColapseDelegate?
    var section: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandColapseButton.layer.cornerRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func expandColapseButtonTapped(_ sender: Any) {
        delegate?.toogle(section: section)
    }
    
}
