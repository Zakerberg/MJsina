//
//  MJVisitorViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/17.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
// 访客视图基类
// 如果未登录 显示的是访客视图view  也就是visitorView
// 如果登录 显示的是一个列表 也就是tableView
class MJVisitorViewController: UIViewController {

    //判断用户是否登录
    let isLogin:Bool = MJOAuthViewModel.shared.isLogin
    
    // 定义个访客视图View 也可以使用懒加载 (可选值和懒加载都有延迟创建的特点)
    var visitorView:MJVisitorView?
    // 列表
    lazy var tableView: UITableView = UITableView()
    
    override func loadView() {
      
//      登录
        if isLogin {
            
            view = tableView
            
        }else{
            
//     未登录
       setupVisitorView()
        }
    }
    
    /*
     - VisitorVc 强引用了 visitorView
     - visitorView 强引用了 闭包
     - 闭包 强引用了 VisitorVc
     - A-B-闭包-A
     */
    // 实例化visitorView
    private func setupVisitorView(){
//   未登录的状态创建导航按钮
      setupNav()
  
     visitorView = MJVisitorView()

     //设置代理
//    visitorView?.delegate = self
      
        //实例化闭包
        visitorView?.closure = {[weak self] in
        
        self?.loginClick()
    }
   view = visitorView
    
}
    
//    设置导航
    private func setupNav(){
        
//    左侧
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: nil, title: "登录", target: self, action: #selector(loginClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: nil, title: "注册", target: self, action: #selector(loginClick))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        // 微博登录与注册弹出控制器
    @objc private func loginClick(){
        
        //模态弹出微博登录控制器
//        实例化
        let oauthVc = MJOAuthViewController()
        //模态形式弹出控制器
        self.present(MJNavController(rootViewController:oauthVc), animated: true, completion: nil)
    
    }
}
