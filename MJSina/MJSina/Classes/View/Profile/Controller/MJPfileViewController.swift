//
//  MJPfileViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJPfileViewController: MJVisitorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置访客视图的信息
        if !isLogin {
            visitorView?.setupVistorViewInfo(title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人", imgName: "visitordiscover_image_profile")
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
