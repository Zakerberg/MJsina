//
//  MJEmoticonPageViewCell.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/11.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJEmoticonPageViewCell: UICollectionViewCell {
    
    // indexPath
    var indexPath: IndexPath?{
        didSet{
            
        }
    }
    
    // 定义一个属性供外界赋值(每一页通过一个一维数组完成赋值)
    var emoticons:[MJEmoticonModel]?{
        didSet{
            
            // 吧20个按钮全部隐藏
            for button in emoticonButtonArray {
                button.isHidden = true
            }
            
            // 遍历模型数组(0,7)
            for (i,emoticonModel) in emoticons!.enumerated(){
                // 获取button
                let button = emoticonButtonArray[i]
                // 赋值操作
                button.emoticonModel = emoticonModel
                // 显示button
                button.isHidden = false
                // 给button赋值
                // 判断是emoji
                if emoticonModel.isEmoji {
                    let code = ((emoticonModel.code ?? "") as NSString).emoji()
                    // 设置title
                    button.setTitle(code, for: UIControlState.normal)
                    // imaeg 设置为nil
                    button.setImage(nil, for: UIControlState.normal)
                    
                }else{
                    let path = emoticonModel.path ?? ""
                    // 获取bundle文件中图片
                    let image = UIImage(named: path, in: MJEmoticonTools.shared.emoticonBundle, compatibleWith: nil)
                    // 图片表情
                    button.setImage(image, for: UIControlState.normal)
                    // title 设置为nil
                    button.setTitle(nil, for: UIControlState.normal)
                }
            }
        }
    }
    
    // 定义一个数组保存按钮
    var emoticonButtonArray:[MJEmoticonButton] = [MJEmoticonButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 设置添加20个表情按钮frame
    override func layoutSubviews() {
        super.layoutSubviews()
        // 计算按钮的宽和高
        let buttonW = (MJSCREENW - 10) / CGFloat(MJEMOTICONMAXCOL)
        let buttonH = (216 - 35 - 20) / CGFloat(MJEMOTICONMAXROW)
        // 设置frame
        // 遍历按钮数组
        for (i,button) in emoticonButtonArray.enumerated() {
            // 列索引
            let colIndex = CGFloat(i%MJEMOTICONMAXCOL)
            // 行索引
            let rowIndex = CGFloat(i/MJEMOTICONMAXCOL)
            // 设置frame
            button.frame = CGRect(x: 5 + colIndex*buttonW, y: rowIndex*buttonH, width: buttonW, height: buttonH)
        }
        
        // 设置删除按钮的frame
        deleteButton.frame = CGRect(x: MJSCREENW - buttonW - 5, y: buttonH*2, width: buttonW, height: buttonH)
        
    }
    //MARK: - 监听事件
    @objc private func buttonClick(button: MJEmoticonButton){
        // 发送通知 -> 传出按钮对应的模型
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: EMOTICONBUTTONNOTI), object: button.emoticonModel)
    }
    
    @objc private func deleteButtonClick(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: EMOTICONDELETEBUTTONNOTI), object: nil)
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        addChildButtons()
        contentView.addSubview(deleteButton)
    }
    //MARK: - 添加20个表情按钮
    private func addChildButtons(){
        // 循环20次
        for _ in 0..<MJEMOTICONMAXCOUNT {
            // 创建按钮
            let button =  MJEmoticonButton()
            // 监听事件
            button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
            // 设置字体
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            // 设置随机颜色
            //            button.backgroundColor = HMRandomColor()
            // 添加到数组中
            emoticonButtonArray.append(button)
            // 添加
            contentView.addSubview(button)
        }
    }
    
    // 删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        // 点击事件
        button.addTarget(self, action: #selector(deleteButtonClick), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named:"compose_emotion_delete"), for: UIControlState.normal)
        button.setImage(UIImage(named:"compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
        return button
    }()
    
}
