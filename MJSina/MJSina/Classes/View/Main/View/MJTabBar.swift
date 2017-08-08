//
//  MJTabBar.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

//定义协议
protocol MJTabBarDelegate:NSObjectProtocol{
    //定义协议方法
    func composeButtonDidSelected()
    
}

class MJTabBar: UITabBar {

    // 01-声明代理 (使用weak 修饰 需要继承NSObjectProtocol基协议)
    weak var mjDelegate:MJTabBarDelegate?
    
    //01- 声明一个闭包
    var closure :(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    /*
     - required  必须的
     - 如果继承与UIView 但是你采用的手写代码开发项目 系统默认就会给你添加一个方法 initWithCoder 方法
     - 如果你当前的类 被其他的开发者使用 作为sb 或者xib 就会走initWithCoder 方法 告知使用者 该类不支持sb或者xib 创建
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been  implemented")
    }
    
    //MARK: -监听事件
    @objc private func buttonClick(){
        
        
        //03 执行闭包
        closure?()
        // 03
//        hmDelegate?.composeButtonDidSelected()
    }
    //MARK: - 设置视图
    private func setupUI(){
        //添加控件
        addSubview(composeButton)
    }
   override func layoutSubviews() {
        super.layoutSubviews()
    //计算UITabBarButton宽度
    let w = MJSCREENW * 0.2
    
    //还要确定每个UITabBarButton的位置
    var index : CGFloat = 0
    
    
    //因为UITabBarButton是私有的,所以采用遍历
    //遍历tabBar的子控件
    for view in subviews {
        //判断class是否是UITabBarButton
        if view.isKind(of: NSClassFromString("UITabBarButton")!){
            //设置UITabBarButton的宽度和 x
            view.frame.size.width = w
            view.frame.origin.x = index * w
            //UITabBarButton 位置发生变化
            index += 1
            
            //需要给加号按钮留下位置
            if index == 2 {
                index += 1
            }
        }
    }
    //设置composeButton的frame
    composeButton.center.x = frame.width * 0.5
    composeButton.center.y = frame.height * 0.5
    
    }
    

//MARK: - 懒加载控件
//加号按钮

// MARK: - 懒加载控件
// 加号按钮
private lazy var composeButton: UIButton = {
    let btn = UIButton()
    // 点击事件
    btn.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
    // 设置image
    btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
    btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
    // 设置背景图片
    btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: UIControlState.normal)
    btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
    // 设置按钮大小
    btn.sizeToFit()
    return btn
}()

}




