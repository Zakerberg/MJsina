//
//  MJComposeTextView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJComposeTextView: UITextView {
    
    // 共外界设置占位文字
    var placeholder: String?{
        didSet{
            // 设置占位文字
            placeholderLabel.text = placeholder
        }
    }
    
    // 重写font 属性 在didSet方法中监听它设置了多大的字体
    override var font: UIFont?{
        didSet{
            // 设置占位文字的font
            placeholderLabel.font = font
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        //        backgroundColor = HMRandomColor()
        // 添加控件
        addSubview(placeholderLabel)
        // 添加约束
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -10))
        
        // 通过监听系统通知来监听textView 的文字改变
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
    
    // 监听文字改变
    func textChange(){
        placeholderLabel.isHidden = self.hasText
    }
    
    //MARK: - 懒加载控件
    // 占位label
    private lazy var placeholderLabel: UILabel = {
        let lab = UILabel()

        // 设置颜色
        lab.textColor = UIColor.darkGray
        // 换行
        lab.numberOfLines = 0
        return lab
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
