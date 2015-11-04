//
//  BackButton.swift
//  
//
//  Created by Bruce Li on 2015-11-02.
//
//

import UIKit

public final class BackButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup () {
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
        let attributedString = NSAttributedString(string: Icons.Chevron, attributes: attributes)
        setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        titleLabel?.layer.masksToBounds = false
        titleLabel?.layer.shadowRadius = 3.0
        titleLabel?.layer.shadowOpacity = 0.5
        titleLabel?.layer.shadowOffset = CGSize.zero
        titleLabel?.layer.shadowColor = UIColor.grayColor().CGColor
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(40, 40)
    }
    

}
