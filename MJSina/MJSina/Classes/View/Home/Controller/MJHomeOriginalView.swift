//
//  MJHomeOriginalView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import YYText

class MJHomeOriginalView: UIView {
    
    //记录原创微博的底部约束
    var orginalBottomConstraint: Constraint?
    
    // 提供属性供外界赋值
    var statusViewModel: MJStatusViewModel?{
        didSet{
            
            // 赋值
            // 头像
            headImageView.mj_setImage(urlString: statusViewModel?.homeModel?.user?.profile_image_url)
            // 昵称
            nameLabel.text = statusViewModel?.homeModel?.user?.name
            // 内容
//           contentLabel.text = statusViewModel?.homeModel?.text
            
            contentLabel.attributedText = statusViewModel?.originalContentAttributedString
            
            
            // 会员等级
            membershipImageView.image = statusViewModel?.membershipImage
            // 会员认证
            avatarImageView.image = statusViewModel?.avatarImage
            
            //卸载约束
            orginalBottomConstraint?.uninstall()
            
            /*
             - 卸载我们记录的约束 (记录的是原创微博的底部约束)
             - 判断是否有配图 -> 通过pic_urls 来判断
             - 如果 count > 0 代表有配图
             - 赋值
             - 设置约束 (原创微博的bottom == 配图的.bottom + 10)
             - 显示配图
             - 如果 count <= 0 代表没有配图
             - 设置约束 (原创微博的bottom == 微博正文的.bottom + 10)
             - 隐藏配图
             
             */
            // 判断是否有配图 (判断是否为nil 而且是否count > 0)
            // 有配图
            if let picUrls = statusViewModel?.homeModel?.pic_urls,picUrls.count > 0 {
                
                //赋值
                pictureView.pic_urls = picUrls
                
                //约束
                self.snp_makeConstraints(closure: { (make) in
                    orginalBottomConstraint = make.bottom.equalTo(pictureView).offset(10).constraint
                    
                })
                //显示
                pictureView.isHidden = false
                
            }else{
                
                //没有配图
                //约束
                self.snp_makeConstraints(closure: { (make) in
                    orginalBottomConstraint = make.bottom.equalTo(contentLabel).offset(10).constraint
                })
                //隐藏
                pictureView.isHidden = true
            }
            
            // 设置测试数据 -> 后期处理
            timeLabel.text = statusViewModel?.sinaTimeStr
            sourceLabel.text = statusViewModel?.sourceStr
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
        // 设置随即颜色
        backgroundColor = UIColor.white
        // 01- 添加控件
        addSubview(headImageView)
        addSubview(nameLabel)
        addSubview(membershipImageView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(avatarImageView)
        addSubview(contentLabel)
        addSubview(pictureView)
        // 02 添加约束
        headImageView.snp_makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(headImageView.snp_right).offset(10)
            make.top.equalTo(headImageView)
        }
        
        membershipImageView.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_right).offset(10)
            make.centerY.equalTo(nameLabel)
        }
        
        sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(headImageView)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(sourceLabel.snp_right).offset(10)
            make.top.equalTo(sourceLabel)
        }        
        
        avatarImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(headImageView.snp_right)
            make.centerY.equalTo(headImageView.snp_bottom)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(MJSCREENW - 20)
            make.top.equalTo(headImageView.snp_bottom).offset(10)
            // 01 方式
            // make.bottom.equalTo(self).offset(-10)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
        }
        // 02 方式
       // 当前原创微博的底部
        snp_makeConstraints { (make) in
            orginalBottomConstraint = make.bottom.equalTo(pictureView).offset(10).constraint
        }
        
        /*
         // 4. 接受事件回调
         label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
         NSLog(@"tap text range:...");
         };
         */
        // 4. 接受事件回调
        /*
         -containerView 点击的控件contentLabel
         -text  点击的对应的富文本
         -range 高亮范围
         -rect 高亮的frame
         */

        contentLabel.highlightTapAction = {(containerView, text, range, rect)->() in
        
            let result = text.string
            print(result)
            // 通过范围截图目标的字符串
            // 发送通知告知父类的控制器 在吧url 通过object 传到控制器
            // 如果最终的截取出来的内容包含http 在发送通知
        }
    }
    
    //MARK: - 懒加载控件
    // 头像
    private lazy var headImageView: UIImageView = UIImageView(imgName: "avatar_default")
    // 昵称
    private lazy var nameLabel: UILabel = UILabel(fontSize: MJNORMALFONTSIZE, textColor: UIColor.black)
    // 会员等级
    private lazy var membershipImageView: UIImageView = UIImageView(imgName: "common_icon_membership")
    // 时间
    private lazy var timeLabel: UILabel = UILabel(fontSize: MJSMALLFONTSIZE, textColor: MJThemeColor)
    // 来自
    private lazy var sourceLabel: UILabel = UILabel(fontSize: MJSMALLFONTSIZE, textColor: MJThemeColor)
    // 用户认证
    private lazy var avatarImageView: UIImageView = UIImageView(imgName: "avatar_vgirl")
    // 微博正文
    private lazy var contentLabel: YYLabel = {
//        let lab = UILabel(fontSize: MJNORMALFONTSIZE, textColor: UIColor.black)
        let lab = YYLabel()
        // 设置yylabel显示文字的最大宽度
        lab.preferredMaxLayoutWidth = MJSCREENW - 20

        // 换行
        lab.numberOfLines = 0
        //文本行位置调整
        let modifier = YYTextLinePositionSimpleModifier()
        modifier.fixedLineHeight = 22
        lab.linePositionModifier = modifier
        return lab
    }()
    
    //配图
    private lazy var pictureView: MJHomePictureView = {
        
        let view = MJHomePictureView()
        view.backgroundColor = self.backgroundColor
        return view
        
    }()
   
}

