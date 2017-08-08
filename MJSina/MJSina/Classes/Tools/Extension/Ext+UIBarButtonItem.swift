//
//  Ext+UIBarButtonItem.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
// 便利构造函数
/*
 
 - 按钮
 - 01 图片
 - 02 文字
 - 03 图片和文字
 
 */

extension UIBarButtonItem{
   
    convenience init(imgName: String? = nil, title: String? = nil, target: Any?, action:Selector) {
        
        self.init()
        
        //创建一个button
        let btn = UIButton()
        
        //添加点击事件
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        //设置image(带图片的按钮)
        if let img = imgName {
            
            btn.setImage(UIImage(named:img), for: UIControlState.normal)
            btn.setImage(UIImage(named:"\(img)_highligted"), for: UIControlState.highlighted)
        }
        
        //只有文字的按钮
        if let tit = title {
            btn.setTitle(tit, for: UIControlState.normal)
            btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            btn.setTitleColor(MJThemeColor, for: UIControlState.highlighted)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
        }
        
        //设置size
        btn.sizeToFit()
        customView = btn
    }

}









