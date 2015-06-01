//
//  NearbyTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-04-30.
//
//

import UIKit

public final class NearbyTableViewCell: UITableViewCell {


    @IBOutlet weak var bizName: UILabel!
    @IBOutlet weak var bizImage: UIImageView!
    @IBOutlet weak var bizHours: UILabel!
    @IBOutlet weak var bizDetail: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
