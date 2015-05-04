//
//  NearbyTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-04-30.
//
//

import UIKit

class NearbyTableViewCell: UITableViewCell {


    @IBOutlet weak var bizName: UILabel!
    @IBOutlet weak var bizImage: UIImageView!
    @IBOutlet weak var bizHours: UILabel!
    @IBOutlet weak var bizDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}
