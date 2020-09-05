//
//  HunterTextField.swift
//  customTextField
//
//  Created by Zubin Manak on 18/07/20.
//  Copyright © 2020 Ishita. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
 @IBDesignable
    open class HunterTextField: UITextField {

        func setup() {

            
            self.borderStyle = .none
            self.layer.cornerRadius = 57.0/2
            self.layer.backgroundColor = newColor?.cgColor
//                UIColor(hex: "#E4DEEFCB")?.cgColor

        self.layer.masksToBounds = true
            
                if let image = leftImage {
                    if leftView != nil { return } // critical!
                    let frame = CGRect(x: 0, y: (self.frame.height-20)/2.0, width: 20.0, height: 20.0)
                    let im = UIImageView()
                    im.frame = frame
                    im.contentMode = .scaleAspectFit
                    im.image = image
                    
                    leftViewMode = UITextField.ViewMode.always
                    leftView = im
                    
                } else {
                    leftViewMode = UITextField.ViewMode.never
                    leftView = nil
                }
            
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    @IBInspectable var leftImage: UIImage? = nil
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var gapPadding: CGFloat = 0
    @IBInspectable var newColor: UIColor?

    private var textPadding: UIEdgeInsets {
        let p: CGFloat = leftPadding + gapPadding + (leftView?.frame.width ?? 0)
        let q: CGFloat = rightPadding + gapPadding + (leftView?.frame.width ?? 0)
        return UIEdgeInsets(top: 0, left: p, bottom: 0, right: q)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
            var r = super.leftViewRect(forBounds: bounds)
            r.origin.x += leftPadding
            return r
        }
        
    open override func layoutSubviews() {
            super.layoutSubviews()
            setup()
        }
        
 
}
