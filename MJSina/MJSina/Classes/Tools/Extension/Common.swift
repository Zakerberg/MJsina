//
//  Common.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//


import UIKit

/* 
 - 相当于OC中的pch 文件
 */
//切换根控制器的通知名字
let SWITCHEROOTVIEWCONTROLLERNOTI = "SWITCHEROOTVIEWCONTROLLERNOTI"
// 表情按钮点击通知
let EMOTICONBUTTONNOTI = "EMOTICONBUTTONNOTI"
// 删除按钮点击通知
let EMOTICONDELETEBUTTONNOTI = "EMOTICONDELETEBUTTONNOTI"

//新浪微博需要的信息
let APPKEY = "1178834576"
let APPSECRET = "5d33b30ace3acb290f5160edf9ea0c9a"
let REDIRECT_URI = "http://www.baidu.com"

// 新浪微博需要的信息//////////////////////////////////////////////////
//let APPKEY = "4224473119"                                     ///
//let APPSECRET = "dfe5a2b2eec6368b1ff6d86362bf09e7"           ///
//let REDIRECT_URI = "http://www.baidu.com"                    ///
//////////////////////////////////////////////////////////////////


// 主账号
let MJWBNAME = "18604274522"
let MJWBPASSWD = "BLMxlwb1129"

// 微博账号和密码////////////////////////////////////////////
//let HMWBNAME = "rangyuan05788697@163.com"            ////
//let HMWBPASSWD = "bbb333"                           ////
//let HMWBNAME = "jubeisi0516873@163.com"             ////
//let HMWBPASSWD = "958794"                           ////
/////////////////////////////////////////////////////////

// 屏幕的宽度和高度
let MJSCREENW = UIScreen.main.bounds.width
let MJSCREENH = UIScreen.main.bounds.height
// 微博的主题颜色
let MJThemeColor = UIColor.orange
// 常用字体大小(小 普通 大)normal
let MJSMALLFONTSIZE: CGFloat = 10
let MJNORMALFONTSIZE: CGFloat = 14
let MJLARGEFONTSIZE: CGFloat = 18

// RGB颜色
func RGB(r:Float, g: Float, b: Float, alpha: Float = 1) -> UIColor {
    return UIColor(colorLiteralRed: r/Float(255), green: g/Float(255), blue: b/Float(255), alpha: alpha)
}
// 随机颜色
func MJRandomColor() -> UIColor{
    let r =  Float(arc4random()%256)
    let g =  Float(arc4random()%256)
    let b =  Float(arc4random()%256)
    return RGB(r: r, g: g, b: b)
}



