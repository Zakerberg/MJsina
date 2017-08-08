//
//  Ext+NSAttributedString.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/12.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    class func emoticonAttributedString(emoticonModel: MJEmoticonModel) -> NSAttributedString{
        
        //创建一个文本附件
        let att = MJTextAttachment()
        
        //赋值
        att.emoticionModel = emoticonModel
        let path = emoticonModel.path ?? ""
        
        //获取bundle文件中的图片
        let image = UIImage(named: path, in: MJEmoticonTools.shared.emoticonBundle, compatibleWith: nil)
        
        //设置image
        att.image = image
        
        //得到行号
        let font = UIFont.systemFont(ofSize: MJNORMALFONTSIZE)
        let lineHeight = font.lineHeight
        
        //bounds(给image 设置大小)
        att.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        
        //定义一个不可变的富文本
        let attr = NSAttributedString(attachment: att)
        
        return attr
        
    }
}







