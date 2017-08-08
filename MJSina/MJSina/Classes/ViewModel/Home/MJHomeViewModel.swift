//
//  MJHomeViewModel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import SDWebImage
/*
 - 作用:
 - 帮助HomeVc 请求数据
 - 给HomeVc 提供数据
 */
class MJHomeViewModel: NSObject {
    
    // 保存首页数据的数组
    lazy var dataArray: [MJStatusViewModel] = [MJStatusViewModel]()
    
}

// MARK: - 请求微博首页数据
extension MJHomeViewModel{
    /*
     isFinish - ture  false
     
     true  外界刷新ui
     false 告知用户请求失败
     */
    func getHomeData(isPullUp:Bool, isFinish:@escaping (Bool,Int)->()){
        
        // 定义sinceId 和maxId 默认为0
        var sinceId: Int64 = 0
        var maxId: Int64 = 0

        //判断是否是上拉加载更多
        if isPullUp {
            maxId = dataArray.last?.homeModel?.id ?? 0
            
            //按照微博接口的需求
            if maxId > 0 {
                
                maxId = maxId - 1
            }
        }else{
            //下拉刷新
            sinceId = dataArray.first?.homeModel?.id ?? 0
        }
        
        // 请求数据
        MJNetworkTool.shared.loadHomeData(since_id: sinceId, max_id: maxId, success: { (response) in
            // 判断response 是否为nil 而且是否可以转成字典
            guard let resDict = response as? [String: Any] else {
                // 执行闭包
                isFinish(false,0)
                return
            }
            //resDict["statuses"] 是否为nil(数组)
            guard let res = resDict["statuses"] else {
                // 执行闭包
                isFinish(false,0)
                return
            }
            // OC中获取类型的class -> [Person class]
            // Swift获取类型的class -> Person.self
            // 得到的模型数组
            let statusArray = NSArray.yy_modelArray(with: MJHomeModel.self, json: res)  as! [MJHomeModel]
            // 创建一个临时可以可变的数组-> [HMStatusViewModel]
            var tempArray:[MJStatusViewModel] = [MJStatusViewModel]()
            
            //创建调度组
            let group = DispatchGroup()
            
            // 遍历statusArray 创建statuViewModel 然后对齐身上的homeModel进行赋值 然后 保存到临时数组中
            for homeModel in statusArray{
                
           // 判断原创微博的pic_urls.count 是否等于1 如果等于1 下载图片
                if homeModel.pic_urls?.count == 1 {
                    //进入
                    group.enter()
                    //使用SDWebImage下载
                    SDWebImageManager.shared().downloadImage(with: URL(string: homeModel.pic_urls?.first?.thumbnail_pic ?? ""), options: [], progress: nil, completed: { (image, error, _, _, _) in
                        //出去
                        group.leave()
                    })
                }
            // 判断转发微博的pic_urls.count 是否等于1 如果等于1 下载图片
                if homeModel.retweeted_status?.pic_urls?.count == 1 {
                    
                    group.enter()
                    
                    //使用SDWebImage下载
                    SDWebImageManager.shared().downloadImage(with: URL(string: homeModel.retweeted_status?.pic_urls?.first?.thumbnail_pic ?? ""), options: [], progress: nil, completed: { (image, error, _, _, _) in
                        //出去
                        group.leave()
                    })
                }
                
                let statusViewModel = MJStatusViewModel()
                //对属性进行赋值
                statusViewModel.homeModel = homeModel
                //添加到数组中
                tempArray.append(statusViewModel)
        }
            
            /*
             - 微博数据显示的业务逻辑
             -如果是下拉刷新 得到新的数据 放到原有数组的前面
             -如果是上拉加载更过 得到的数据 放到原有数组的后面
             */
            
            // 赋值
            //如果是上拉加载更多
            if isPullUp {
                
                self.dataArray = tempArray + self.dataArray
                
            }else{
                //下拉刷新
                self.dataArray = tempArray + self.dataArray
            }
            
            // 监听sdwebimage 是否下载完成
            group.notify(queue: DispatchQueue.main, execute: {
                // 执行闭包
                isFinish(true, tempArray.count)
            })
            
        }, failure: {(error)->() in
            print("失败",error)
            // 执行闭包
                isFinish(false,0)
        })
    }
}
