//
//  MJUserAccountModel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/21.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJUserAccountModel: NSObject,NSCoding {

    /// 用户授权的唯一票据
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    /// expires_Data 当前日期 + 过期秒数
    var expires_in: Double = 0{
        
        didSet{
            expires_Date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 授权用户的UID
    var uid: String?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像
    var avatar_large: String?
    /// access_token 过期的日期
    var expires_Date :Date?
    
    //解决该错误 use of unimplemented initializer 'init()' for class 'MJSina.MJUserAccountModel'
    
    override init() {
        super.init()
    }
    
    //归档
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    
     //解档
     required init?(coder aDecoder: NSCoder) {
        super.init()
        self.yy_modelInit(with: aDecoder)
    }
    
    //重写description
    override var description: String{
        
    let keys = ["access_token","expires_Date","uid","screen_name",
            "avatar_large"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

}
 
