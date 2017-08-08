//
//  MJTempViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJTempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - 监听事件
    //    @objc private func leftClick(){
    //        _ = navigationController?.popViewController(animated: true)
    //    }
    
    @objc private func rightClick(){
        
        let tempVc = MJTempViewController()
        navigationController?.pushViewController(tempVc, animated: true)
        
    }
 
    //MARK: - 设置视图
    func setupUI(){
        view.backgroundColor = MJRandomColor()
        setupNav()
    }
    
    //MARK: - 设置导航
    func setupNav(){
        
        //设置title
        title = "第\(navigationController?.childViewControllers.count ?? 0)个控制器"
        //        // 设置左侧按钮
        //        /*
        //          如果你自定义了左侧返回按钮后 那么点击屏幕左侧 进行拖拽就会失效
        //         */
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: "navigationbar_back_withtext", title: "首页", target: self, action: #selector(leftClick))
        
        //设置右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: nil,title: "PUSH", target: self,action: #selector(rightClick))

    }

}



























