//
//  MJEmoticonBottomView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/10.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
/*
 UIStackView ios 9 以后的新控件
 - 注意 他是一个容器视图
 */
enum MJEmoticonBottomViewType: Int {
    case recent = 100
    case normal = 101
    case emoji = 102
    case xlh = 103
}

class MJEmoticonBottomView: UIStackView {
    
    //记录上一次选中的按钮
    var lastBtn: UIButton?
    
    //定义一个闭包^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    var closure:((MJEmoticonBottomViewType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///MARK: -提供一个方法设置当前类里面的按钮状态
    func setupSelectButton(tag: Int){
        //通过tag 获取buuton
        let button = viewWithTag(tag) as! UIButton
        
        //判断如果和lastButton一样 
        if lastBtn == button {
            
            return
        }
        button.isSelected = true
        lastBtn?.isSelected = false
        lastBtn = button

    }

    
    ///MARK: -监听事件
    func buttonClick(button: UIButton) {
        
        //判断如果和lastButton一样
        if lastBtn == button {
            return
        }
        button.isSelected = true
        lastBtn?.isSelected = false
        lastBtn = button
        
        //执行闭包^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        closure?(MJEmoticonBottomViewType(rawValue: button.tag)!)

    }
    //MARK: - 设置视图
    private func setupUI(){

        backgroundColor = MJRandomColor()
        
        // 布局方式
        axis = .horizontal
        //填充方式
        distribution = .fillEqually
        
        addChildButtons(imgName: "left", title: "最近", type:.recent)
        addChildButtons(imgName: "mid", title: "默认", type:.normal)
        addChildButtons(imgName: "mid", title: "Emoji", type:.emoji)
        addChildButtons(imgName: "right", title: "小浪花", type:.xlh)        
        
    }

    //创建按钮的公共方法
    func addChildButtons(imgName: String, title: String, type: MJEmoticonBottomViewType){
        
        let button = UIButton()
        //设置tag
        button.tag = type.rawValue
        
        if title == "默认" {
            button.isSelected = true
            //记录
            lastBtn = button
        }
        //监听事件
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: MJNORMALFONTSIZE)
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitleColor(UIColor.darkGray, for: UIControlState.selected)
        button.setBackgroundImage(UIImage(named:"compose_emotion_table_\(imgName)_normal"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named:"compose_emotion_table_\(imgName)_selected"), for: UIControlState.selected)
        addArrangedSubview(button)
    }
}
