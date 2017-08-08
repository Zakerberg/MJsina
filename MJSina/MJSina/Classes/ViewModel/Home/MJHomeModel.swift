//
//  MJHomeModel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJHomeModel: NSObject {
    // MARK: - 模型属性
    /// 创建时间
    var created_at: Date?
    /// 微博ID
    var id: Int64 = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 用户模型
    var user: MJUserModel?
    /// 转发微博模型
    var retweeted_status: MJHomeModel?
    /// 配图数组
    var pic_urls: [MJPictureModel]?
    
    //返回容器类中所需要存放分数据类型(已Class 或者 Class Name 的形式)
    //类方法 前缀修饰符为class
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["pic_urls":MJPictureModel.self]
    }
    //    + (NSDictionary *)modelContainerPropertyGenericClass {
    //    return @{@"shadows" : [Shadow class],
    //    @"borders" : Border.class,
    //    @"attachments" : @"Attachment" };
    //    }
    
}
