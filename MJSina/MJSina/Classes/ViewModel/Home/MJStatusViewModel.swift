//
//  MJStatusViewModel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import YYText
/*
 - view 级别的ViewModel
 - 对HomeModel的数据 进行处理
 */

class MJStatusViewModel: NSObject {

    var homeModel: MJHomeModel?{
        
        didSet{
            //处理会员等级逻辑
            membershipImage = dealMemberShipImage(mbrank: homeModel?.user?.mbrank ?? 0)
            
            ///处理用户等级类型逻辑
            avatarImage = dealMemberShipImage(mbrank: homeModel?.user?.verified ?? -1)
            
            ///微博来源
            sourceStr = dealSinaSource(source: homeModel?.source)
            
            ///原创微博
            originalContentAttributedString = dealContentAttributedString(text: homeModel?.text ?? "")
            
            //转发微博
            retweetAttributedSrtring = dealContentAttributedString(text: homeModel?.retweeted_status?.text ?? "")
        }
    }
    
    //会员等级image
    var membershipImage: UIImage?
    
    //用户认证类型
    var avatarImage: UIImage?
    
    ///来源
    var sourceStr:String?
    
    ///时间
    var sinaTimeStr: String?{
        return dealSinaTime(creatAt: homeModel?.created_at)
    }
    
    //原创微博的富文本
    var originalContentAttributedString: NSMutableAttributedString?
    
    //转发微博的富文本
    var retweetAttributedSrtring: NSMutableAttributedString?
    
}


///MARK: - 处理首页的图文混排
extension MJStatusViewModel {
    
    // 处理首页的图文混排
    func dealContentAttributedString(text: String) -> NSMutableAttributedString{
        // 把内容字符串转成一个可变的富文本
        let allAttr = NSMutableAttributedString(string: text)
        
        // [拜拜拜拜]
        // 使用正则匹配我们想要的格式内容
        let matchResult = try! NSRegularExpression(pattern: "\\[[\\w]+\\]", options: []).matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        // 倒着遍历匹配到的结果集合
        for match in matchResult.reversed() {
            let result = (text as NSString).substring(with: match.range)
            // 得到对应的模型
            let emoticonModel = MJEmoticonTools.shared.getEmoticonModelWith(chs: result)
            // 创建一个不可变的富文本
            //            let attr = NSAttributedString.emoticonAttributedString(emoticonModel: emoticonModel)
            // 使用yyLable 就要使用yytext的构造方法创建可变的富文本
            let path = emoticonModel?.path
            if let p = path {
                // 获取bundle文件中图片
                let image = UIImage(named: p, in: MJEmoticonTools.shared.emoticonBundle, compatibleWith: nil)!
                let attr = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: MJNORMALFONTSIZE)!
                // 吧图片描述替换成不可变的富文本
                allAttr.replaceCharacters(in: match.range, with: attr)
            }
        }
        
        // 设置富文本的字体大小
        allAttr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: MJNORMALFONTSIZE)], range: NSRange(location: 0, length: allAttr.length))
        // 设置富文本高亮属性
        // 匹配用户// \u4e00-\\u9fa5汉字
        addHighLightedAttributedString(allAttr: allAttr, pattern: "@[a-zA-Z0-9\\u4e00-\\u9fa5_\\-]+")
        // 话题
        addHighLightedAttributedString(allAttr: allAttr, pattern: "#[^#]+#")
        // url
        addHighLightedAttributedString(allAttr: allAttr, pattern: "([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.',;]*)?")
        return allAttr
    }
    
    // 设置富文本上的高亮效果
    /*
     匹配用户：@[a-zA-Z0-9\\u4e00-\\u9fa5_\\-]+
     匹配话题：#[^#]+#
     匹配URL：([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.',;]*)?
         */
        
        func addHighLightedAttributedString(allAttr: NSMutableAttributedString, pattern: String){
            // 把传入的可变富文本转成字符串
            let text = allAttr.string
            // 通过正则匹配结果集合
            let matchResult = try! NSRegularExpression(pattern: pattern, options: []).matches(in: text, options: [], range: NSRange.init(location: 0, length: text.characters.count))
            
            //遍历集合
            for match in matchResult {
                
                // 设置富文本点击高亮后的背景颜色
                //cornerRadius 圆角
                let border = YYTextBorder(fill: UIColor.black, cornerRadius: 3)
                
                //设置
                border.insets = UIEdgeInsetsMake(1, -2, 0, -2)
                //创建文本高亮对象
                let highlight = YYTextHighlight()
                
                //设置高亮下文字的颜色
                highlight.setColor(MJThemeColor)
                // 设置背景yanse
                highlight.setBackgroundBorder(border)
                //把"高亮"属性设置到某个文本范围
                allAttr.yy_setTextHighlight(highlight, range: match.range)
                // 匹配到结果后设置默认颜色
                allAttr.addAttributes([NSForegroundColorAttributeName:UIColor.red], range: match.range)
                
            }
            /*
             YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor grayColor] cornerRadius:3];
             
             YYTextHighlight *highlight = [YYTextHighlight new];
             [highlight setColor:[UIColor whiteColor]];
             [highlight setBackgroundBorder:highlightBorder];
             highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
             NSLog(@"tap text range:...");
             // 你也可以把事件回调放到 YYLabel 和 YYTextView 来处理。
             };
             
             // 2. 把"高亮"属性设置到某个文本范围
             [attributedText yy_setTextHighlight:highlight range:highlightRange];
             */
    }
}


//MARK: - 处理用户相关的逻辑
extension MJStatusViewModel{
    
    ///会员等级1-6
    func dealMemberShipImage(mbrank: Int)-> UIImage? {
        
        if mbrank >= 1 && mbrank <= 6{
            return UIImage (named: "common_icon_membership_level\(mbrank)")
        }else{
            return UIImage (named: "common_icon_membership")
        }
    }
    
    ///认证类型
    func dealAvatarImage(verified: Int) -> UIImage? {
        switch verified {
        case 1:
            return UIImage(named: "avatar_vip")            
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return UIImage(named: "avatar_vgirl")
        }
    }
    
    //MARK: 处理微博来源
    /*
     Optional("<a href=\"http://app.weibo.com/t/feed/3auC5p\" rel=\"nofollow\">皮皮时光机</a>")
     
     */
    func dealSinaSource(source: String?) ->String{
        
        //判断source是否为nil,而且不包含\">
        guard  let s = source, s.contains("\">") else {
            return "来自: Michael 柏"
        }
        
        let start = s.range(of: "\">")!
        
        let end = s.range(of: "</a")!
        
        let result = s.substring(with: start.upperBound..<end.lowerBound)

        return "来自:" + result
    }
    
    ///处理微博时间
    func dealSinaTime(creatAt: Date?) -> String?{
        
        guard let sinaDate = creatAt else {
            return nil
        }
        
        //时间格式化
        let df = DateFormatter()
        
        let isThisYear = sinaDateisThisYear(sinaDate: sinaDate)
        
        if isThisYear {
            
            let calendar = Calendar.current
            
            if calendar.isDateInToday(sinaDate) {
                let s = abs(sinaDate.timeIntervalSinceNow)
                
                if s <= 60  {
                    return "刚刚"
                }else if s > 60 && s < 60*60 {
                    return "\(Int(s/60))分钟前"
                }else{
                    return "\(Int(s/(60*60)))小时前"
                }
                
            }else if calendar.isDateInYesterday(sinaDate){
                
                df.dateFormat = "昨天 HH:mm"
                return df.string(from: sinaDate)
            
            }else {
                
                df.dateFormat = "MM-dd HH:mm"
                return df.string(from: sinaDate)

            }

        }else {
            
            df.dateFormat = "yyyy-MM-dd HH:mm"
            print(df.string(from: sinaDate))
            return df.string(from: sinaDate)
        }

    }
    
    
    func sinaDateisThisYear(sinaDate: Date) ->Bool{
        
        let currentDate = Date()
        
        let df = DateFormatter()
        
        df.dateFormat = "yyyy"
        
        let surrentStr = df.string(from: currentDate)
        
        let sinaStr = df.string(from: sinaDate)
        
        return surrentStr == sinaStr
        
    }
}





