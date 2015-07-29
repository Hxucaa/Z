//
//  NicknameTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-07-19.
//
//

import UIKit

public final class NicknameTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editProfilePicButton: UIButton!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textField.placeholder = "昵称"
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
