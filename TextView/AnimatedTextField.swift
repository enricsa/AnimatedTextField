//
//  TextField.swift
//  
//
//  Created by twb on 6/14/15.
//
//

import UIKit

@IBDesignable public class AnimatedTextField: UITextField {

    // MARK: Initializer
    
    private func setup() {
        borderStyle = UITextBorderStyle.None
        
        addSubview(placeholderLabel)
        addSubview(textLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Customization points

    public let textLabel = UILabel()
    public let placeholderLabel = UILabel()

    public func textFieldDidBeginEditing() {
        textLabel.hidden = true
        
        UIView.animateWithDuration(0.20, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func textFieldDidEndEditing() {
        textLabel.text = text
        if let text = text {
            textLabel.hidden = text.isEmpty
        } else {
            textLabel.hidden = true
        }
        
        UIView.animateWithDuration(0.20, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: Properties
    
    @IBInspectable public override var placeholder: String? {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable public override var font: UIFont! {
        didSet {
            updateProperties()
        }
    }
    
    public func updateProperties() {
        textLabel.font = font
        textLabel.text = text
        
        placeholderLabel.font = font
        placeholderLabel.text = placeholder
        placeholderLabel.sizeToFit()
        
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: UITextField overrides
    
    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        if let text = text {
            let textSize: CGSize = text.sizeWithAttributes([NSFontAttributeName:font])
            return CGRect(
                origin: CGPoint(
                    x: textLabel.frame.origin.x,
                    y: textLabel.frame.origin.y - (0.5 * (bounds.height - textSize.height))
                ),
                size: bounds.size
            )
        } else {
            return bounds
        }
    }
    
    public override func drawPlaceholderInRect(rect: CGRect) {
        // don't draw superviews placeholder label
    }
    
    public override func drawTextInRect(rect: CGRect) {
        // don't draw superviews text label
    }
    
    // MARK: Notifications
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        #if !TARGET_INTERFACE_BUILDER
            let notificationCenter = NSNotificationCenter.defaultCenter();
            if newSuperview != nil {
                notificationCenter.addObserver(self, selector: "textFieldDidBeginEditing", name:UITextFieldTextDidBeginEditingNotification, object: self)
                notificationCenter.addObserver(self, selector: "textFieldDidEndEditing", name:UITextFieldTextDidEndEditingNotification, object: self)
            } else {
                notificationCenter.removeObserver(self);
            }
        #endif
    }
    
}
