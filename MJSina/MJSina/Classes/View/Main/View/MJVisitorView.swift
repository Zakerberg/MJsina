//
//  MJVisitorView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/17.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

//声明协议
protocol MJVisitorViewDelegate :NSObjectProtocol{
    
    //协议方法
    func visitorViewButtonClick()
    
}

class MJVisitorView: UIView {

//    01- 定义一个闭包
    var closure :(()->())?
    
//    声明代理
    weak var delegate:MJVisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 按钮监听事件
    @objc private func buttonClick(){
//        03- 执行闭包
        closure?()
        // 执行
        //        delegate?.visitorViewButtonClick()
    }
    
//       MARK: - 供外界设置的方法
    func setupVistorViewInfo(title: String?, imgName: String? ){
        if  let tit = title,let img = imgName {
            
            messageLabel.text = tit
            iconImageView.image = UIImage(named: img)
            feedImageView.isHidden = true
        }else{
           
//            代表是首页
//            执行动画
            setupMaskImageViewAnim()
        }
    }
    
//      设置圆圈动画
        func setupMaskImageViewAnim(){
//      核心动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = M_PI * 2
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        // 当切换控制器 或者程序退到后台 默认动画会被移除
        anim.isRemovedOnCompletion = false
        
        feedImageView.layer.add(anim, forKey: nil)
    }

//      MARK: - 设置圆圈的动画
        private func setupUI(){
        backgroundColor = RGB(r: 235, g: 235, b: 235)
//      01 -添加控件
        addSubview(feedImageView)
        addSubview(maskImageView)
        addSubview(iconImageView)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
    
//      02 - 添加约束
        feedImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        maskImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        iconImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(maskImageView.snp_bottom).offset(16)
            make.width.equalTo(230)
            make.centerX.equalTo(self)
        }

        loginButton.snp_makeConstraints { (make) in
            make.left.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(16)
            make.size.equalTo(CGSize(width: 100, height: 35))

        }
        registerButton.snp_makeConstraints { (make) in
            make.size.equalTo(loginButton)
            make.top.equalTo(loginButton)
            make.right.equalTo(messageLabel)
        }
    }
    // MARK: - 懒加载控件
    // 圆圈图片
    private lazy var feedImageView: UIImageView = UIImageView(imgName: "visitordiscover_feed_image_smallicon")
    // 遮挡
    private lazy var maskImageView: UIImageView = UIImageView(imgName: "visitordiscover_feed_mask_smallicon")
    // icon
    private lazy var iconImageView: UIImageView = UIImageView(imgName: "visitordiscover_feed_image_house")
    // 文字
    lazy var messageLabel: UILabel = {
        let lab = UILabel(fontSize: MJNORMALFONTSIZE, textColor: UIColor.darkGray, text: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜")
        // 换行
        lab.numberOfLines = 0
        // 对齐方式
        lab.textAlignment = .center
        return lab
    }()

    
    //    设置登录按钮和注册按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        
        //    点击事件
        btn.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        btn.setBackgroundImage(UIImage(named: "common_button_white"), for: UIControlState.normal)
        
        //    设置文字
        btn.setTitle("登录", for: UIControlState.normal)
        //    设置文字颜色
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.setTitleColor(MJThemeColor, for: UIControlState.highlighted)
        //设置字体大小
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        return btn
        
    }()
    
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        
        //    点击事件
        btn.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        btn.setBackgroundImage(UIImage(named: "common_button_white"), for: UIControlState.normal)
        
        //    设置文字
        btn.setTitle("注册", for: UIControlState.normal)
        //    设置文字颜色
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.setTitleColor(MJThemeColor, for: UIControlState.highlighted)
        //设置字体大小
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return btn
        
    }()    
}

/*
 
extension MJVisitorView {
    
    func test(){
        
        
      设置为false才能添加约束
        约束与Autosizing控制。。。
        当打开约束的时候，要约束条件完全，否则可能试图丢失。。。。。
 

      feedImageView.translatesAutoresizingMaskIntoConstraints = false
 
       02 - 添加约束
         -item 添加约束的对象
         - attribute 约束条件
         - relatedBy 约束方式
         - toItem 参考对象
         - attribute 约束条件
         - multiplier 倍数
         - constant 偏移量
 
        addConstraint(NSLayoutConstraint(item: feedImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: feedImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    }
}
 
*/








