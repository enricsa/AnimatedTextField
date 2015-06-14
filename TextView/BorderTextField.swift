//
//  TWBTextField.swift
//  
//
//  Created by twb on 6/11/15.
//
//

import UIKit

@IBDesignable public class BorderTextField: AnimatedTextField {

    let underlineView = UIView()

    // MARK: Initializer
    
    private func setup() {
        updateProperties()
        addSubview(underlineView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Properties
    
    @IBInspectable public var underlineColor: UIColor? = UIColor.blackColor() {
        didSet {
            updateProperties()
        }
    }

    @IBInspectable public var underlineThickness: CGFloat = 1.0 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable public var placeholderMinimizedScale: CGFloat = 0.7

    public override func updateProperties() {
        underlineView.backgroundColor = underlineColor
        super.updateProperties()
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        var textSize = CGSize(width: 0, height: 0)
        var placeholderSize = CGSize(width: 0, height: 0)
        if let text = text {
            textSize = text.sizeWithAttributes([NSFontAttributeName:font])
        }
        if let placeholder = placeholder {
            placeholderSize = placeholder.sizeWithAttributes([NSFontAttributeName:font])
        }

        textLabel.frame = CGRect(
            origin: CGPoint(x: 0, y: ceil(placeholderMinimizedScale * placeholderSize.height)),
            size: textSize
        )
        
        if editing {
            underlineView.frame = CGRect(
                origin: CGPoint(x: 0, y: frame.height - (underlineThickness * 2)),
                size: CGSize(width: frame.width, height: underlineThickness * 2)
            )
        } else {
            underlineView.frame = CGRect(
                origin: CGPoint(x: 0, y: frame.height - underlineThickness),
                size: CGSize(width: frame.width, height: underlineThickness)
            )
        }
        
        if text == nil || text!.isEmpty && !editing {
            placeholderLabel.transform = CGAffineTransformIdentity
            placeholderLabel.center = CGPoint(x: 0.5 * placeholderSize.width, y: placeholderSize.height * placeholderMinimizedScale + (0.5 * placeholderSize.height))
        } else {
            placeholderLabel.center = CGPoint(x: 0.5 * placeholderSize.width * placeholderMinimizedScale, y: 0.5 * placeholderSize.height * placeholderMinimizedScale)
            placeholderLabel.transform = CGAffineTransformMakeScale(placeholderMinimizedScale, placeholderMinimizedScale)
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        let size = super.intrinsicContentSize()
        
        if let placeholder = placeholder {
            let placeholderSize: CGSize = placeholder.sizeWithAttributes([NSFontAttributeName:font])
            
            return CGSize(
                width: size.width,
                height: ceil(placeholderSize.height * placeholderMinimizedScale) + size.height + underlineThickness * 2
            )
        }
        
        return size
    }
    
}
