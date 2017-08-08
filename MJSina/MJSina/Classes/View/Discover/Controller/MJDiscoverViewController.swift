//
//  MJDiscoverViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJDiscoverViewController: MJVisitorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置访客视图的信息
        if !isLogin {
            visitorView?.setupVistorViewInfo(title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过", imgName: "visitordiscover_image_message")
            return
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
