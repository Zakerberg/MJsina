//
//  MJNavController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJNavController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 当自定义导航左侧按钮后 点击屏幕左侧不能返回的bug 解决方法
        interactivePopGestureRecognizer?.delegate = self
        
    }

    //将要接收手势点击
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        return childViewControllers.count != 1
    }
    
    
    //重写push 方法 完成监听来代码抽取的
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //进入的二级控制器
        if childViewControllers.count > 0 {
            //设置title
            var title = "返回"
            
            if childViewControllers.count  == 1 {
                
                title = childViewControllers.first?.title ?? ""
                
                //隐藏
                viewController.hidesBottomBarWhenPushed = true
                
            }
            // 设置左侧按钮
            /*
             如果你自定义了左侧返回按钮后 那么点击屏幕左侧 进行拖拽就会失效
             */
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(imgName:"navigationbar_back_withtext",title: title,target: self,action: #selector(leftClick))
        }
        super.pushViewController(viewController, animated: animated)
    }
   
    //MARK: - 监听事件
    @objc private func leftClick(){
       _ = popViewController(animated: true)
    }

}



