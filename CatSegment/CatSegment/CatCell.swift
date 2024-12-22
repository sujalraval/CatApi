//
//  CatCell.swift
//  CatSegment
//
//  Created by Manthan Mittal on 22/12/2024.
//

import UIKit

class CatCell: UITableViewCell {

    @IBOutlet weak var lid: UILabel!
    
    @IBOutlet weak var lurl: UILabel!
    
    @IBOutlet weak var lwidth: UILabel!
    
    @IBOutlet weak var lheight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
