//
//  WhatsupTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-07-19.
//
//

import UIKit

public final class WhatsupTableViewCell: UITableViewCell {

    @IBOutlet private weak var textField : UITextField!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.placeholder = "心情"
        textField.delegate = self
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension WhatsupTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
