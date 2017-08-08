//
//  Ext+UIImage.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK:- 截屏 -> 主window 的内容  
    class func screenShot() -> UIImage?{
        // 01 拿到主window
        let window = UIApplication.shared.keyWindow!
        // 02 开启上下文
        UIGraphicsBeginImageContext(window.frame.size)
        // 03 把window上的的内容渲染到上下文中
        // afterScreenUpdates 屏幕更新后在渲染 还是不更新后渲染
        window.drawHierarchy(in: window.frame, afterScreenUpdates: false)
        // 04 从上下文中获取到image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 05 关闭上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    // 图片压缩策略 等比例压缩
    // 如果宽度大于400(width) 就需要压缩处理

    func dealImageScale(width: CGFloat) -> UIImage{
        //如果image的宽度小于等于400 直接返回
        if self.size.width <= width {
            return self
        }
        // 大于400 也就是大约width
        /*
         1200      400
         800        x
         */
        // 比例结果
        // 比例后的高度
       let h = width*self.size.height/self.size.width
        // 01 开启上下文
        UIGraphicsBeginImageContext(CGSize(width: width, height: h))
        // 02 吧image 渲染到上下文中
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: h))
        // 03 从上下文中获取image
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 04 关闭上下文
        UIGraphicsEndImageContext()
        // 05 返回image
        return image

    }
}







