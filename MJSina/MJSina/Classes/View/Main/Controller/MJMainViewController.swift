//
//  MJMainViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //实例化自定义的tabBar
         let tabBar = MJTabBar()
        
        //设置代理
        tabBar.mjDelegate = self
        
//       02- 实例化闭包
        tabBar.closure = {
            
            //04 - 闭包回调
            print("MJMainViewController监听到了按钮点击")
            
            let composeView = MJComposeView()
            composeView.show(target: self)
            
        }
    //通过kvc 给只读属性赋值
        setValue(tabBar, forKey: "tabBar")
        
       addChildViewController(MJHomeController(), title: "首页", imgName: "tabbar_home")
        
       addChildViewController(MJMessageViewController(), title: "消息", imgName: "tabbar_message_center")
        
        addChildViewController(MJDiscoverViewController(), title: "发现", imgName: "tabbar_discover")
        
        addChildViewController(MJPfileViewController(), title: "我", imgName: "tabbar_profile")
    }
}
// MARK: - 添加子控制器的公共方法时
extension MJMainViewController {
    /// 添加子控制器的公共方法时
    ///
    /// - Parameters:
    ///   - childController: 控制器
    ///   - title: 名字
    ///   - imgName: 图片名称

        func addChildViewController(_ childController:UIViewController,title: String, imgName: String){
            
           //设置title
            childController.title = title;
          
            //设置title颜色
            childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: MJThemeColor], for: UIControlState.selected)
            // 设置image
            // withRenderingMode 渲染方式
            // alwaysOriginal 采用图片原生颜色
   
            childController.tabBarItem.image = UIImage(named:imgName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
            childController.tabBarItem.selectedImage = UIImage(named:"\(imgName)_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
            //添加子控制器
            addChildViewController(MJNavController(rootViewController:childController))
        }
    }

// MARK: - HMTabBarDelegate
/*
 - extension 类似于OC中的categroy (给类添加方法)
 - 格式: extension 类名 {}
 - Swift 可读性很差 通过extension 完成代码分块
 - extension 可以添加计算型属性 不能添加存储型属性 可以定义便利构造函数 不能定义 指定构造函数
 */
extension MJMainViewController: MJTabBarDelegate{
    // 04
    func composeButtonDidSelected() {
        print("HMMainViewController监听到了按钮点击")
    }
}

















