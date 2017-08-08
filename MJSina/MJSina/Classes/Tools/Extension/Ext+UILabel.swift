
//
//  Ext+UILabel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/4.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//
import UIKit

extension UILabel {
    
    /// 快速创建一个lable
    ///
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - textColor: 字体颜色
    ///   - text: 文字
    convenience init(fontSize: CGFloat, textColor: UIColor, text: String? = nil){
        self.init()
        // 字体大小
        self.font = UIFont.systemFont(ofSize: fontSize)
        // 字体颜色
        self.textColor = textColor
        // 设置text
        self.text = text
    }
    
}
