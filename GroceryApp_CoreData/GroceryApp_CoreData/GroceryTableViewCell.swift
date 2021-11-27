//
//  GroceryTableViewCell.swift
//  GroceryApp_CoreData
//
//  Created by Rayan Taj on 24/11/2021.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    @IBOutlet weak var namelabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
