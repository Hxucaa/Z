//
//  WhatsupTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-07-19.
//
//

import UIKit
import ReactiveCocoa

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
    
    public func getTextfield_rac_text () -> MutableProperty<String?> {
        return textField.rac_text
    }
    
    public func setTextfieldText (text: MutableProperty<String?>) {
        textField.text = text.value
    }

}

extension WhatsupTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
