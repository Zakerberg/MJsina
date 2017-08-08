//
//  MJMessageViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJMessageViewController: MJVisitorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置访客视图的信息
        if !isLogin {
            visitorView?.setupVistorViewInfo(title:  "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知", imgName: "visitordiscover_image_message")
            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
