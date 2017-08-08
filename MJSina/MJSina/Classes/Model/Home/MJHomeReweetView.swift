//
//  MJHomeReweetView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJHomeReweetView: UIView {
    
    //记录转发微博的底部约束
    var reweetViewBottomContraint:Constraint?
    

    // 提供属性供外界赋值 -> viewModel
    var statusViewModel: MJStatusViewModel?{
        didSet{
            // 赋值
//            contentLabel.text = statusViewModel?.homeModel?.retweeted_status?.text
            contentLabel.attributedText = statusViewModel?.retweetAttributedSrtring
            
            //先卸载约束
            reweetViewBottomContraint?.uninstall()
            /*
             - 有配图
             - 赋值** 一定要先赋值 要不约束可能有问题
             - 设置约束(转发微博的bottom == 配图的bottom + 10)
             - 显示配图
             */
         
            if let picUrls = statusViewModel?.homeModel?.retweeted_status?.pic_urls, picUrls.count > 0{
                
                //赋值
                pictureView.pic_urls = picUrls
                
                //设置约束
                self.snp_makeConstraints(closure: { (make) in
                    reweetViewBottomContraint = make.bottom.equalTo(pictureView).offset(10).constraint
                })
                
                //显示配图
                pictureView.isHidden = false
            }else{
                /*
                 - 没有配图
                 - 设置约束(转发微博的bottom == 微博内容的bottom + 10)
                 - 隐藏配图
                 
                 */
                // 设置约束
                self.snp_makeConstraints(closure: { (make) in
                    reweetViewBottomContraint = make.bottom.equalTo(contentLabel).offset(10).constraint
              })
                //隐藏配图
                pictureView.isHidden = true
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        // 随机颜色
        backgroundColor = RGB(r: 235, g: 235, b: 235)        
        // 01 添加控件
        addSubview(contentLabel)
        addSubview(pictureView)
        // 02 添加约束
        contentLabel.snp_makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.equalTo(MJSCREENW - 20)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            // 在配图内容已经计算好了
            //            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        // 约束转发微博的底部
        snp_makeConstraints { (make) in
            reweetViewBottomContraint = make.bottom.equalTo(pictureView).offset(10).constraint
        }
        
    }
    //MARK: - 懒加载控件
    // 内容
    private lazy var contentLabel: UILabel = {
        let lab = UILabel(fontSize: MJNORMALFONTSIZE, textColor: UIColor.darkGray)
        // 换行
        lab.numberOfLines = 0
        return lab
    }()
    
    //配图
    private lazy var pictureView: MJHomePictureView = {
        
        let view = MJHomePictureView()
        view.backgroundColor = self.backgroundColor
        return view
    }()
    
}
