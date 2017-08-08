//
//  MJWelcomeViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/4.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import SDWebImage


/*
   和控制器一样大小的背景图片
   用户头像
   文字
 
 */
class MJWelcomeViewController: UIViewController {

    override func loadView() {
        view = bgImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 更新约束
        self.headImageView.snp_updateConstraints(closure: { (make) in
            make.top.equalTo(self.view).offset(100)
        })
        
        // 设置动画
        /*
         withDuration- 动画时长
         delay - 延迟时间
         Damping -  阻尼系数 (范围0-1 阻尼系数越小 弹性效果越好)
         Velocity - 起始速度
         options - 选项
         */
        UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {()->() in
            
            // 强行刷新当前ui
            self.view.layoutIfNeeded()
            
        }, completion: {(_)->() in
            // 动画完成以后
            UIView.animate(withDuration: 0.25, animations: {
                self.messageLabel.alpha = 1
            }, completion: { (_) in
                // 发送通知切换根控制器 跟控制 为HMMainVc
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SWITCHEROOTVIEWCONTROLLERNOTI), object: "welcomeVc")
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        // 01 添加控件
        view.addSubview(headImageView)
        view.addSubview(messageLabel)
        // 02 添加约束
        headImageView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 90, height: 90))
            make.top.equalTo(view).offset(400)
            make.centerX.equalTo(view)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(headImageView.snp_bottom).offset(16)
            make.centerX.equalTo(headImageView)
        }
        
    }
    
    //MARK: - 懒加载控件
    // 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(imgName: "ad_background")
    // 用户头像
    private lazy var headImageView: UIImageView = {
        let img = UIImageView(imgName: "avatar_default")
        // 圆角
        img.layer.cornerRadius = 45
        img.layer.masksToBounds = true
        // 边框
        img.layer.borderColor = MJThemeColor.cgColor
        img.layer.borderWidth = 1
        // 设置image
        //        img.sd_setImage(with: URL(string: HMOAuthViewModel.shared.userAccountModel?.avatar_large ?? ""), placeholderImage: UIImage(named: "avatar_default"))
        img.mj_setImage(urlString: MJOAuthViewModel.shared.userAccountModel?.avatar_large)
        return img
    }()
    // 文字
    private lazy var messageLabel: UILabel = {
        let lab = UILabel()
        lab.text = "欢迎回来,Zakerberg"
        // 对齐
        lab.textAlignment = .center
        // 透明度
        lab.alpha = 0
        return lab
    }()
    
}











