//
//  BoxedTextField.swift
//  
//
//  Created by twb on 6/14/15.
//
//

import UIKit

import UIKit

@IBDesignable public class BoxedTextView: AnimatedTextField {
    
    let boxView = UIView()
    
    // MARK: Initializer
    
    private func setup() {
        boxColor = UIColor.redColor()
        boxView.userInteractionEnabled = false
        
        placeholderLabel.textColor = UIColor.whiteColor()
        boxView.layer.cornerRadius = 5.0
        layer.cornerRadius = 5.0
        
        addSubview(boxView)
        bringSubviewToFront(textLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Properties
    
    @IBInspectable public var boxColor: UIColor? = UIColor.whiteColor() {
        didSet {
            boxView.backgroundColor = boxColor
        }
    }
    
    @IBInspectable public var padding: CGFloat = 5.0 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable public var placeholderMinimizedScale: CGFloat = 0.7
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var textSize = CGSize(width: 0, height: 0)
        var placeholderSize = CGSize(width: 0, height: 0)
        if let text = text, font = font {
            textSize = text.sizeWithAttributes([NSFontAttributeName:font])
        }
        if let placeholder = placeholder, font = font {
            placeholderSize = placeholder.sizeWithAttributes([NSFontAttributeName:font])
        }

        textLabel.frame = CGRect(
            origin: CGPoint(x: 2 * padding, y: ceil(placeholderMinimizedScale * placeholderSize.height) + 2 * padding),
            size: textSize
        )
        
        if text == nil || text!.isEmpty && !editing {
            placeholderLabel.transform = CGAffineTransformIdentity
            placeholderLabel.center = CGPoint(x: 0.5 * placeholderSize.width + padding, y: placeholderSize.height * placeholderMinimizedScale + (0.5 * placeholderSize.height) + padding)
            
            boxView.frame = CGRect(
                origin: CGPoint(x: 0, y: frame.height - padding),
                size: CGSize(width: frame.width, height: 0.0)
            )
        } else {
            placeholderLabel.center = CGPoint(x: 0.5 * placeholderSize.width * placeholderMinimizedScale + padding, y: 0.5 * placeholderSize.height * placeholderMinimizedScale + padding)
            placeholderLabel.transform = CGAffineTransformMakeScale(placeholderMinimizedScale, placeholderMinimizedScale)
            
            boxView.frame = CGRect(
                origin: CGPoint(x: padding, y: ceil(placeholderMinimizedScale * placeholderSize.height) + padding),
                size: CGSize(width: frame.width - 2 * padding, height: textSize.height + 2 * padding)
            )
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        let size = super.intrinsicContentSize()
        
        if let placeholder = placeholder, font = font {
            let placeholderSize: CGSize = placeholder.sizeWithAttributes([NSFontAttributeName:font])
            
            return CGSize(
                width: size.width,
                height: ceil(placeholderSize.height * placeholderMinimizedScale) + size.height + (4 * padding)
            )
        }
        
        return size
    }
    
}
