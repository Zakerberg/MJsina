//
//  MJHomeBottomView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJHomeBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        
        // 添加按钮
        let retweetButton = addChildButton(imgName: "timeline_icon_retweet", title: "转发")
        let commentButton = addChildButton(imgName: "timeline_icon_comment", title: "评论")
        let likeButton = addChildButton(imgName: "timeline_icon_unlike", title: "赞")
        
        retweetButton.addTarget(self, action: #selector(retweetBtnClick), for: UIControlEvents.touchUpInside)
        commentButton.addTarget(self, action: #selector(commentBtnClick), for: UIControlEvents.touchUpInside)
        likeButton.addTarget(self, action: #selector(lickBtnClick), for: UIControlEvents.touchUpInside)
        
        
        // 添加竖线
        let l1 = addChildLine()
        let l2 = addChildLine()
        
        // 添加约束
        retweetButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(commentButton)
        }
        
        commentButton.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(retweetButton.snp_right)
            make.width.equalTo(likeButton)
        }
        
        likeButton.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(commentButton.snp_right)
        }
        
        l1.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(retweetButton.snp_right)
        }
        
        l2.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(commentButton.snp_right)
        }
        
    }
}


//MARK: - 抽取公共方法
extension MJHomeBottomView{
    // 创建按钮
    func addChildButton(imgName: String, title: String) -> UIButton{
        let button = UIButton()
        // 设置背景图片
        button.setBackgroundImage(UIImage(named:"timeline_card_bottom_background"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named:"timeline_card_bottom_background_highlighted"), for: UIControlState.highlighted)
        button.setImage(UIImage(named:imgName), for: UIControlState.normal)
        button.setTitle(title, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: MJNORMALFONTSIZE)
        button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        // 添加控件
        addSubview(button)
        return button
    }
    
    //转发按钮点击事件
    @objc fileprivate func retweetBtnClick() {
    
        
    }
    
    @objc fileprivate func commentBtnClick() {
        
    }
    
    @objc fileprivate func lickBtnClick() {
        
        
    
    }

    
    // 创建竖线
    func addChildLine() -> UIImageView{
        let img = UIImageView(imgName: "timeline_card_bottom_line")
        // 添加控件
        addSubview(img)
        return img
    }
}













