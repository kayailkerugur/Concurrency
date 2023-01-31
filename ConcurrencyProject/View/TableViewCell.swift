//
//  TableViewCell.swift
//  ConcurrencyProject
//
//  Created by İlker Kaya on 31.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
