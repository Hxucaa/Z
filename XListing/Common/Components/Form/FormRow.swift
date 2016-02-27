//
//  FormRow.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-06.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import Eureka

@IBDesignable public class FloatLabelTextField: UITextField {
    private let animationDuration = 0.3
    private let title = UILabel()
    private let detail = UILabel()
    
    // MARK:- Properties
    override public var accessibilityLabel:String! {
        get {
            if text?.isEmpty ?? true {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    override public var placeholder:String? {
        didSet {
            title.text = placeholder
            title.sizeToFit()
        }
    }
    
    override public var attributedPlaceholder:NSAttributedString? {
        didSet {
            title.text = attributedPlaceholder?.string
            title.sizeToFit()
        }
    }
    
    var titleFont: UIFont = .systemFontOfSize(12.0) {
        didSet {
            title.font = titleFont
            title.sizeToFit()
        }
    }
    
    @IBInspectable var hintYPadding:CGFloat = 0.0
    
    @IBInspectable var titleYPadding:CGFloat = 0.0 {
        didSet {
            var r = title.frame
            r.origin.y = titleYPadding
            title.frame = r
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = .grayColor() {
        didSet {
            if !isFirstResponder() {
                title.textColor = titleTextColour
            }
        }
    }
    
    @IBInspectable var titleActiveTextColour: UIColor! {
        didSet {
            if isFirstResponder() {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    var detailFont = UIFont.systemFontOfSize(12.0) {
        didSet {
            detail.font = titleFont
            detail.sizeToFit()
        }
    }
    
    @IBInspectable var detailYPadding: CGFloat = 0.0 {
        didSet {
            var r = detail.frame
            r.origin.y = detailYPadding
            detail.frame = r
        }
    }
    
    @IBInspectable var detailTextColour: UIColor = .redColor() {
        didSet {
            if !isFirstResponder() {
                title.textColor = titleTextColour
            }
        }
    }
    
    @IBInspectable var detailActiveTextColour: UIColor! {
        didSet {
            if isFirstResponder() {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    // MARK: - Init
    required public init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    // MARK:- Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        setDetailPositionForTextAlignment()
        let isResp = isFirstResponder()
        if isResp && !(text?.isEmpty ?? true) {
            title.textColor = titleActiveTextColour
        } else {
            title.textColor = titleTextColour
        }
        // Should we show or hide the title label?
        if text?.isEmpty ?? true {
            // Hide
            hideTitle(isResp)
        } else {
            // Show
            showTitle(isResp)
        }
    }
    
    override public func textRectForBounds(bounds:CGRect) -> CGRect {
        var r = super.textRectForBounds(bounds)
        if !(text?.isEmpty ?? true){
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        }
        return CGRectIntegral(r)
    }
    
    override public func editingRectForBounds(bounds:CGRect) -> CGRect {
        var r = super.editingRectForBounds(bounds)
        if !(text?.isEmpty ?? true) {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        }
        return CGRectIntegral(r)
    }
    
    override public func clearButtonRectForBounds(bounds:CGRect) -> CGRect {
        var r = super.clearButtonRectForBounds(bounds)
        if !(text?.isEmpty ?? true) {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
        }
        return CGRectIntegral(r)
    }
    
    // MARK:- Public Methods
    
    // MARK:- Private Methods
    private func setup() {
        borderStyle = UITextBorderStyle.None
        titleActiveTextColour = tintColor
        // Set up title label
        title.alpha = 0.0
        title.font = titleFont
        title.textColor = titleTextColour
        if let str = placeholder where !str.isEmpty {
            title.text = str
            title.sizeToFit()
        }
        self.addSubview(title)
    }
    
    private func maxTopInset()->CGFloat {
        return max(0, floor(bounds.size.height - (font?.lineHeight ?? 0) - 4.0))
    }
    
    private func setTitlePositionForTextAlignment() {
        let r = textRectForBounds(bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.Center {
            x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
        } else if textAlignment == NSTextAlignment.Right {
            x = r.origin.x + r.size.width - title.frame.size.width
        }
        title.frame = CGRect(x:x, y: title.frame.origin.y, width: title.frame.size.width, height: title.frame.size.height)
    }
    
    private func setDetailPositionForTextAlignment() {
        let r = textRectForBounds(bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.Center {
            x = r.origin.x + (r.size.width * 0.5) - detail.frame.size.width
        } else if textAlignment == NSTextAlignment.Right {
            x = r.origin.x + r.size.width - detail.frame.size.width
        }
        detail.frame = CGRect(x:x, y: detail.frame.origin.y, width: detail.frame.size.width, height: detail.frame.size.height)
    }
    
    private func showTitle(animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState.union(UIViewAnimationOptions.CurveEaseOut), animations:{
            // Animation
            self.title.alpha = 1.0
            var r = self.title.frame
            r.origin.y = self.titleYPadding
            self.title.frame = r
            }, completion:nil)
    }
    
    private func hideTitle(animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState.union(UIViewAnimationOptions.CurveEaseIn), animations:{
            // Animation
            self.title.alpha = 0.0
            var r = self.title.frame
            r.origin.y = self.title.font.lineHeight + self.hintYPadding
            self.title.frame = r
            }, completion:nil)
    }
    
    private func showDetail(animated: Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animateWithDuration(dur, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState.union(UIViewAnimationOptions.CurveEaseOut), animations: {
            // Animation
            self.detail.alpha = 1.0
            var r = self.detail.frame
            r.origin.y = self.detailYPadding
            self.detail.frame = r
            }, completion: nil)
    }
    
    private func hideDetail(animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState.union(UIViewAnimationOptions.CurveEaseIn), animations:{
            // Animation
            self.title.alpha = 0.0
            var r = self.title.frame
            r.origin.y = self.title.font.lineHeight + self.hintYPadding
            self.title.frame = r
            }, completion:nil)
    }
}

public class _FloatLabelCell<T where T: Equatable, T: InputTypeInitiable>: Cell<T>, UITextFieldDelegate, TextFieldCell {
    
    public var textField : UITextField { return floatLabelTextField }
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    lazy public var floatLabelTextField: FloatLabelTextField = { [unowned self] in
        let floatTextField = FloatLabelTextField()
        floatTextField.translatesAutoresizingMaskIntoConstraints = false
        floatTextField.font = .preferredFontForTextStyle(UIFontTextStyleBody)
        floatTextField.titleFont = .boldSystemFontOfSize(11.0)
        floatTextField.detailFont = .boldSystemFontOfSize(11.0)
        floatTextField.clearButtonMode = .WhileEditing
        return floatTextField
        }()
    
    
    public override func setup() {
        super.setup()
        height = { 55 }
        selectionStyle = .None
        contentView.addSubview(floatLabelTextField)
        floatLabelTextField.delegate = self
        floatLabelTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        //        floatLabelTextField.
        contentView.addConstraints(layoutConstraints())
    }
    
    public override func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        floatLabelTextField.attributedPlaceholder = NSAttributedString(string: row.title ?? "", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        floatLabelTextField.text =  row.displayValueFor?(row.value)
        floatLabelTextField.enabled = !row.isDisabled
        floatLabelTextField.titleTextColour = .lightGrayColor()
        floatLabelTextField.alpha = row.isDisabled ? 0.6 : 1
    }
    
    public override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && floatLabelTextField.canBecomeFirstResponder()
    }
    
    public override func cellBecomeFirstResponder(direction: Direction) -> Bool {
        return floatLabelTextField.becomeFirstResponder()
    }
    
    public override func cellResignFirstResponder() -> Bool {
        return floatLabelTextField.resignFirstResponder()
    }
    
    private func layoutConstraints() -> [NSLayoutConstraint] {
        let views = ["floatLabeledTextField": floatLabelTextField]
        let metrics = ["vMargin":8.0]
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-[floatLabeledTextField]-|", options: .AlignAllBaseline, metrics: metrics, views: views) + NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options: .AlignAllBaseline, metrics: metrics, views: views)
    }
    
    public func textFieldDidChange(textField : UITextField){
        guard let textValue = textField.text else {
            row.value = nil
            return
        }
        if let fieldRow = row as? FormatterConformance, let formatter = fieldRow.formatter where fieldRow.useFormatterDuringInput {
            let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.alloc(1))
            let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?> = nil
            if formatter.getObjectValue(value, forString: textValue, errorDescription: errorDesc) {
                row.value = value.memory as? T
                if var selStartPos = textField.selectedTextRange?.start {
                    let oldVal = textField.text
                    textField.text = row.displayValueFor?(row.value)
                    if let f = formatter as? FormatterProtocol {
                        selStartPos = f.getNewPosition(forPosition: selStartPos, inTextInput: textField, oldValue: oldVal, newValue: textField.text)
                    }
                    textField.selectedTextRange = textField.textRangeFromPosition(selStartPos, toPosition: selStartPos)
                }
                return
            }
        }
        guard !textValue.isEmpty else {
            row.value = nil
            return
        }
        guard let newValue = T.init(string: textValue) else {
            row.updateCell()
            return
        }
        row.value = newValue
    }
    
    //MARK: TextFieldDelegate
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        formViewController()?.beginEditing(self)
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        formViewController()?.endEditing(self)
    }
}

public class TextFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .Default
        textField.autocapitalizationType = .Sentences
        textField.keyboardType = .Default
    }
}



public class FloatFieldRow<T: Any, Cell: CellType where Cell: BaseCell, Cell: TextFieldCell, Cell.Value == T>: Row<T, Cell> {
    
    public var formatter: NSFormatter?
    public var useFormatterDuringInput: Bool
    
    public required init(tag: String?) {
        useFormatterDuringInput = false
        super.init(tag: tag)
        self.displayValueFor = { [unowned self] value in
            guard let v = value else {
                return nil
            }
            if let formatter = self.formatter {
                if self.cell.textField.isFirstResponder() {
                    if self.useFormatterDuringInput {
                        return formatter.editingStringForObjectValue(v as! AnyObject)
                    }
                    else {
                        return String(v)
                    }
                }
                return formatter.stringForObjectValue(v as! AnyObject)
            }
            else{
                return String(v)
            }
        }
    }
}

public final class TextFloatLabelRow: FloatFieldRow<String, TextFloatLabelCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
