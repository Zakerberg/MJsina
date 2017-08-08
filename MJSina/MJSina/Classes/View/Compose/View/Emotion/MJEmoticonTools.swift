//
//  MJEmoticonTools.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/11.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
// 最大列数
let MJEMOTICONMAXCOL = 7
// 最大行数
let MJEMOTICONMAXROW = 3
// 每一页显示最多的表情个数
let MJEMOTICONMAXCOUNT = MJEMOTICONMAXCOL*MJEMOTICONMAXROW - 1
class MJEmoticonTools: NSObject {
    // 全局访问点
    static let shared:MJEmoticonTools = MJEmoticonTools()
    
    // 路径
    let file = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("recent.archiver")
    
    // 表情bundle
    lazy var emoticonBundle:Bundle = {
        // 路径
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
        // 获取bundle
        let bundle = Bundle(path: path)!
        return bundle
    }()
    // 最近表情一维数组 最多就是20个
    lazy var recentEmoticons:[MJEmoticonModel] = {
        return self.getRecentEmoticons()
    }()
    // 默认表情一维数组
    lazy var normalEmoticons:[MJEmoticonModel] = {
        return self.loadEmoticonsArray(name: "default")
    }()
    // emoji表情一维数组
    lazy var emojiEmoticons:[MJEmoticonModel] = {
        return self.loadEmoticonsArray(name: "emoji")
    }()
    // 浪小花表情一维数组[40] 变成 [20] [20] 整合成 [[20],[20]]
    lazy var lxhEmoticons:[MJEmoticonModel] = {
        return self.loadEmoticonsArray(name: "lxh")
    }()
    
    // 三维数组
    lazy var allEmoticons:[[[MJEmoticonModel]]] = {
        return [
            [self.recentEmoticons],
            self.loadEmoticonsGroupArray(emoticons: self.normalEmoticons),
            self.loadEmoticonsGroupArray(emoticons: self.emojiEmoticons),
            self.loadEmoticonsGroupArray(emoticons: self.lxhEmoticons)
        ]
    }()
    
    
}
// 做最近表情的保存和获取的操作
extension MJEmoticonTools{
    // 保存表情模型
    func saveRecentModel(emoticonModel: MJEmoticonModel){
        
        // 遍历当前的最近表情的数组 -> 去重
        for (i,model) in recentEmoticons.enumerated() {
            // 判断你的类型 emoji 还是 图片
            if model.isEmoji {
                // emoji
                if model.code == emoticonModel.code {
                    recentEmoticons.remove(at: i)
                }
            }else {
                //图标表情
                if model.png == emoticonModel.png {
                    recentEmoticons.remove(at: i)
                }
            }
        }
        
        // 添加到最近表情数组中
        recentEmoticons.insert(emoticonModel, at: 0)
        // 判断如果超过20个 干掉最后一个
        if recentEmoticons.count > 20 {
            recentEmoticons.removeLast()
        }
        
        // 三维数组中的最近表情的数组进行更改
        allEmoticons[0][0] = recentEmoticons
        
        // 保存到沙盒中
        NSKeyedArchiver.archiveRootObject(recentEmoticons, toFile: file)
    }
    
    // 从沙盒中获取是否有没有最近表情的数组
    func getRecentEmoticons() -> [MJEmoticonModel]{
        
        // 判断沙盒中是否保存了
        if let emoticons = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [MJEmoticonModel] {
            return emoticons
        }else{
            // 第一次没有保存
            return [MJEmoticonModel]()
        }
    }
}

extension MJEmoticonTools {
    
    func getEmoticonModelWith(chs: String) -> MJEmoticonModel?{
        
        // 遍历默认表情 -> 图片
        for model in self.normalEmoticons {
        // 判断外界传入的chs 是否和模型中的chs 相同
            if model.chs == chs {
                return model
            }
        }
        
        // 遍历浪小花表情 -> 图片
        for model in self.lxhEmoticons {
            if model.chs == chs {
                return model
            }
        }
        // 本地没有我们想要的模型
        return nil
    }
}


extension MJEmoticonTools{
    // 通过该方法分别获取不同的表情包的一维数组
    func loadEmoticonsArray(name: String) -> [MJEmoticonModel]{
        // 路径
        let file = emoticonBundle.path(forResource: "\(name)/info.plist", ofType: nil)!
        // plist 数组
        let plistArray = NSArray(contentsOfFile: file)!
        // 通过yymodel 字典转模型
        let tempArray = NSArray.yy_modelArray(with: MJEmoticonModel.self, json: plistArray) as! [MJEmoticonModel]
        // 遍历tempArray
        for model in tempArray{
            // 给path 赋值
            model.path = "\(name)" + "/" + "\(model.png ?? "")"

        }
        return tempArray
    }
    
    // 通过该方法把一维数组转成二维数组
    func loadEmoticonsGroupArray(emoticons:[MJEmoticonModel]) -> [[MJEmoticonModel]]{
        // 得到一维数组将要在表情键盘显示的页数
        let pageCount = (emoticons.count + MJEMOTICONMAXCOUNT - 1)/MJEMOTICONMAXCOUNT
        // 创建一个二维数组可变的 空数组
        var groupArray:[[MJEmoticonModel]] = [[MJEmoticonModel]]()
        for i in 0..<pageCount{
            // 位置
            let loc = i * MJEMOTICONMAXCOUNT
            // 长度
            var len = MJEMOTICONMAXCOUNT
            // 反之越界
            if len + loc > emoticons.count {
                len = emoticons.count - loc
            }
            // 范围
            let range = NSRange(location: loc, length: len)
            // 截取数组
            let tempArray = (emoticons as NSArray).subarray(with: range) as! [MJEmoticonModel]
            // 添加到二维数组中
            groupArray.append(tempArray)
        }
        // 返回
        return groupArray
        
    }
}
