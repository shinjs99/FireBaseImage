//
//  TableViewCell.swift
//  SwiftFirebase
//
//  Created by 하동훈 on 19/12/2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgJson: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
