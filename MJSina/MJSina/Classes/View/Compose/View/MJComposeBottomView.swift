//
//  MJComposeBottomView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

// 定义枚举 com + option 鼠标左键 选择你想要的部分
enum MJComposeBottomViewType: Int {
    // 图片
    case picture = 0
    // @
    case mention = 1
    // #
    case trend = 2
    // 笑脸
    case emoticon = 3
    // +
    case add = 4
}

class MJComposeBottomView: UIView {
    
    
    // 01 声明闭包
    var closure:((MJComposeBottomViewType)->())?
    
    // 表情按钮
    var emoticonButton: UIButton?
    
    // 提供一个属性判断是表情键盘还是系统键盘
    var isEmoticon: Bool = false{
        didSet{
            
            var imgName = ""
            // 如果是自定义表情键盘
            if isEmoticon {
                // 图片改成的是键盘的图片
                imgName = "compose_keyboardbutton_background"
                
            }else {
                // 如果是系统键盘
                // 图片改成的是笑脸图片
                imgName = "compose_emoticonbutton_background"
            }
            
            emoticonButton?.setImage(UIImage(named:imgName), for: UIControlState.normal)
            emoticonButton?.setImage(UIImage(named:"\(imgName)_highlighted"), for: UIControlState.highlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 监听事件
    @objc private func buttonClick(button: UIButton) {
        // 03执行
        // 通过枚举的值 转成枚举名
        closure?(MJComposeBottomViewType(rawValue: button.tag)!)
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        backgroundColor = MJRandomColor()
        let pictureButton = addChildButtons(imgName: "compose_toolbar_picture", type: .picture)
        let mentionButton = addChildButtons(imgName: "compose_mentionbutton_background", type: .mention)
        let trendButton = addChildButtons(imgName: "compose_trendbutton_background",  type: .trend)
        emoticonButton = addChildButtons(imgName: "compose_emoticonbutton_background",  type: .emoticon)
        let addButton = addChildButtons(imgName: "compose_add_background",  type: .add)
        
        // 添加约束
        pictureButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(mentionButton)
        }
        
        mentionButton.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(pictureButton.snp_right)
            make.width.equalTo(trendButton)
        }
        
        trendButton.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(mentionButton.snp_right)
            make.width.equalTo(emoticonButton!)
        }
        
        emoticonButton!.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(trendButton.snp_right)
            make.width.equalTo(addButton)
        }
        
        addButton.snp_makeConstraints { (make) in
            make.left.equalTo(emoticonButton!.snp_right)
            make.top.right.bottom.equalTo(self)
        }
    }
    
    //MARK: - 定义一个方法 负责创建button
    private func addChildButtons(imgName: String, type: MJComposeBottomViewType) -> UIButton{
        // 实例化按钮
        let button = UIButton()
        // 设置tag
        button.tag = type.rawValue
        // 添加事件
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        // 设置背景图片
        button.setBackgroundImage(UIImage(named:"compose_toolbar_background"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named:"compose_toolbar_background"), for: UIControlState.highlighted)
        // 设置iamge
        button.setImage(UIImage(named:imgName), for: UIControlState.normal)
        button.setImage(UIImage(named:"\(imgName)_highlighted"), for: UIControlState.highlighted)
        // 添加按钮
        addSubview(button)
        return button
    }
    
}
