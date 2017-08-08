
//
//  MJComposeButton.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJComposeButton: UIButton {

    
    // 定义一个属性供外界赋值
    var composeModel: MJComposeModel?
    
    // 因为设置按钮放大动画后 如果button按钮存在高亮效果 会导致效果不对 需要干掉高亮效果
    override var isHighlighted: Bool{
        get{
            return false
        }
        set{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置imageView 的frame
        // 大小
        imageView?.frame.size = CGSize(width: self.frame.size.width, height: self.frame.size.width)
        // Y周
        imageView?.frame.origin.y = 0
        
        // 设置titleLabel的frame
        titleLabel?.frame.size = CGSize(width: self.frame.size.width, height: self.frame.size.height - self.frame.size.width)
        // 设置X 和 Y
        titleLabel?.frame.origin.x = 0
        titleLabel?.frame.origin.y = self.frame.size.width
        
    }
    
    
    //MARK: - 设置视图
    private func setupUI(){
        //        backgroundColor = HMRandomColor()
        // 设置imageView 的填充方式
        imageView?.contentMode = .center
        // titleLabel的文字对齐方式
        titleLabel?.textAlignment = .center
        // font
        titleLabel?.font = UIFont.systemFont(ofSize: MJNORMALFONTSIZE)
        // 颜色
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
}
