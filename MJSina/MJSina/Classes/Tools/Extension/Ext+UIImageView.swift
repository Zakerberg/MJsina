//
//  Ext+UIImageView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/17.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    /// UIImageView便利构造函数
    ///
    /// - Parameter imgName: 传入图片的名称
    convenience init(imgName: String){
        self.init(image: UIImage(named:imgName))
    }
    
    /// 对sdwebimage 进行封装
    ///
    /// - Parameter urlString: <#urlString description#>
    func mj_setImage(urlString: String?){
        self.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: self.image)
    }

    
    
    
    
}














