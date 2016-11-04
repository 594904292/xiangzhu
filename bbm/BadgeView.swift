//
//  BadgeView.swift
//  BadgeView
//
//  Created by Shannon Wu on 1/12/16.
//  Copyright © 2016 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: BadgeView

@IBDesignable class BadgeView: UIView {
    @IBInspectable var fontColor: UIColor = UIColor.white {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 11 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var value: Int = -1 {
        didSet {
            if value < 0 {
                text = nil
            } else if value == 0 {
                text = ""
                state = .flag
            } else if value < 10 {
                text = "\(value)"
                state = .numericRound
            } else if value < 100 {
                text = "\(value)"
                state = .numericSquare
            } else {
                text = "99+"
                state = .numericSquare
            }
            
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var flagSize: CGSize = CGSize(width: 7.0, height: 7.0)
    
    fileprivate var text: String? {
        didSet {
            if text == nil {
                isHidden = true
            } else {
                isHidden = false
            }
        }
    }
    
    fileprivate let edgeInsets = UIEdgeInsets(top: 2.0, left: 10.0, bottom: 2.0, right: 10.0)
    
    fileprivate enum State {
        case numericRound
        case numericSquare
        case flag
    }
    fileprivate var state: State = .flag
    
    fileprivate var textSize: CGSize {
        return (text ?? ("" as NSString) as String).size(attributes: textAttributes)
    }
    
    fileprivate var textAttributes: [String : AnyObject]? {
        return  [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: fontColor
        ]
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Set corner radius
        switch state {
        case .flag:
            layer.cornerRadius = rect.height / 2.0
            return
        case .numericRound:
            layer.cornerRadius = rect.height / 2.0
        case .numericSquare:
            layer.cornerRadius = cornerRadius
        }
        clipsToBounds = true
        
        // Draw text
        let textFrame = CGRect(origin: CGPoint(x: (rect.width - textSize.width) / 2.0, y: (rect.height - textSize.height) / 2.0), size: textSize)
        (text ?? ("" as NSString) as String).draw(in: textFrame, withAttributes: textAttributes)
    }
    
    override var intrinsicContentSize : CGSize {
        switch state {
        case .flag:
            return flagSize
        case .numericRound:
            let dimension = max(textSize.width + edgeInsets.right + edgeInsets.left, textSize.height + edgeInsets.top + edgeInsets.top + edgeInsets.bottom)
            return CGSize(width: dimension, height: dimension)
        case .numericSquare:
            return CGSize(width: textSize.width + edgeInsets.right + edgeInsets.left, height: textSize.height + edgeInsets.top + edgeInsets.top + edgeInsets.bottom)
        }
    }
}
