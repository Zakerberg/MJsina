
//
//  MJHomeCell.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJHomeCell: UITableViewCell {
    
    //记录底部视图的顶部约束
    var bottomViewTopConstraint: Constraint?
    
    // 提供属性供外界赋值
    var statusViewModel: MJStatusViewModel?{
        didSet{
            // 给原创微博赋值
            originalView.statusViewModel = statusViewModel
            /*
             - 如果有转发微博  需要显示转发微博 给转发微博赋值
             - 如果没有转发微博 不需要显示转发微博 不给转发微博赋值
             - 目前我们需要拿到一个临界点 如何来判断是否有转发微博 -
             */
            
            //            // 给转发微博赋值
            //
            // 每次重新对底部视图顶部约束之前 要把以前底部视图的顶部约束干掉
            // 卸载约束
            bottomViewTopConstraint?.uninstall()
            // 判断是否有转发微博
            // 有转发微博
            /*
             - 给转发微博赋值
             - 更改底部视图的顶部约束 (bottomView.Top == reweetViewBottom)
             - 显示转发微博
             */
            if statusViewModel?.homeModel?.retweeted_status != nil{
                //01
                retweetView.statusViewModel = statusViewModel
                //02
                bottomView.snp_makeConstraints(closure: { (make) in
                    
                 bottomViewTopConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
                })
                
                //03
                retweetView.isHidden = false
            }else{
                // 没有转发微博
                /*
                 - 更改底部视图的顶部约束 (bottomViwe.Top == originalView.bottom)
                 - 隐藏转发微博
                 */
                // 01
                
                bottomView.snp_makeConstraints(closure: { (make) in
                 bottomViewTopConstraint = make.top.equalTo(originalView.snp_bottom).constraint
                })
                //02
                retweetView.isHidden = true
                
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        // 设置随即颜色
        backgroundColor = RGB(r: 235, g: 235, b: 235)
        // 01 添加控件
        contentView.addSubview(originalView)
        contentView.addSubview(retweetView)
        contentView.addSubview(bottomView)
        // 02 添加约束
        originalView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            // 该约束需要在原创微博内部来约束 通过contentLabel 来计算他的告诉
            //            make.height.equalTo(50)
            make.top.equalTo(8)
        }
        
        retweetView.snp_makeConstraints { (make) in
            // 转发微博的高度需要在转发微博内部计算出来
            //            make.height.equalTo(50)
            make.left.right.equalTo(contentView)
            make.top.equalTo(originalView.snp_bottom)
        }
        
        bottomView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(retweetView.snp_bottom)
            make.height.equalTo(35)
            make.bottom.equalTo(contentView)
        }
        //        // 在Swift3.0以前通过这种方式来约束
        //        contentView.snp_makeConstraints { (make) in
        //            make.left.right.top.equalTo(self)
        //            make.bottom.equalTo(bottomView)
        //        }
        //
    }
    
    //MARK: - 懒加载控件
    // 原创微博
    private lazy var originalView: MJHomeOriginalView = MJHomeOriginalView()
    // 转发微博
    private lazy var retweetView: MJHomeReweetView = MJHomeReweetView()
    // 底部视图
    private lazy var bottomView: MJHomeBottomView = MJHomeBottomView()
    
}
















