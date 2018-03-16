//
//  UIExtensions.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit


func LS(_ S: String) -> String {
    
    return NSLocalizedString(S, comment: "")
    
}

extension UIImage {
    
    func tint(with color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIView {
    
    func roundCorners()
    {
        roundCorners(with: self.frame.size.height / 2.0)
    }
    
    func roundCorners(with radius: CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func addGradientWithColor(colorTop: UIColor, colorBottom: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension UIColor {
    
    static func colorRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return colorRGB(red, green, blue, alpha: 1.0)
    }
    
    static func colorRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha : CGFloat) -> UIColor {
        
        return UIColor.init(red: red / 255.0,
                            green: green / 255.0,
                            blue: blue / 255.0, alpha: alpha)
        
    }
    
}
