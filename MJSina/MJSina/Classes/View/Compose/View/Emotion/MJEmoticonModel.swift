//
//  MJEmoticonModel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/11.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJEmoticonModel: NSObject,NSCoding {
    // emoji表情需要的
    // 十六进制字符串
    var code: String?
    // 图片表情需要的
    // 图片描述
    var chs: String?
    // 图片名
    var png: String?
    
    // 类型(1是emoji表情 0 是图片表情)
    var type: String?{
        didSet{
            isEmoji = (type == "1")
        }
    }
    
    // 是否是emoji表情
    var isEmoji: Bool = false
    // 全路径
    var path: String?
    
    // 解决该错误 fatal error: use of unimplemented initializer 'init()' for class 'HMVVeibo23.HMUserAccountModel'
    override init() {
        super.init()
    }
    
    // 归档
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    
    // 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.yy_modelInit(with: aDecoder)
    }
}
