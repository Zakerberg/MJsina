//
//  MJOAuthViewModel.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/23.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
/*
    1. - 帮助OAuthVc请求数据
    2. - 帮助OAuth保存用户模型和提供数据给其他控制器
 
 */
class MJOAuthViewModel: NSObject {
    
    //全局访问点
    static let shared : MJOAuthViewModel = MJOAuthViewModel()
    
    //1.路径
    let file = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("userAccount.archiver")

    //个人信息数据(解决频繁访问沙盒的问题)
    var userAccountModel: MJUserAccountModel?
    
    
    ///访问令牌()
    var accessToken: String? {
        
//        //第一次登陆
//        if  userAccountModel == nil {
//            
//            return nil
//        }else{
//            ///不是第一次登陆,已经保存过数据
//            ///但是需要判断是否过期'
//            /// 代表没有过期
//            if  userAccountModel?.expires_Data?.compare(Date()) == ComparisonResult.orderedAscending{
//                return userAccountModel?.access_token
//                
//            }else{
//                ///已经过期了
//                return nil
//            }
//        }
//        
        if  userAccountModel?.expires_Date?.compare(Date()) == ComparisonResult.orderedDescending {
            return userAccountModel?.access_token
            
        }else{
            ///已经过期了
            return nil
        }
    }
    
    ///判断用户是否登陆
    /*
     acessToken 有值 代表登陆,fa反之,没有登陆
     */
    var isLogin: Bool {
        
        return accessToken !=  nil
    } 
    
    //重写init方法
    override init (){
        super.init()
        //给userAccountModel赋值
        userAccountModel = getUserAccountModel()
        
    }
   
}

//保存和获取用户信息数据模型
extension MJOAuthViewModel{
    
    //保存模型
    func saveUserAccountModel(userAccountModel:MJUserAccountModel){
//      解决第一次获取数据为nil的问题
        self.userAccountModel = userAccountModel
                
        //2.保存
        NSKeyedArchiver.archiveRootObject(userAccountModel, toFile: file)        
    }
    
    //获取模型
    func getUserAccountModel() -> MJUserAccountModel?{
        
        //2.获取  
        // 为什么使用as? 如果用户首次登陆 没有保存数据 获取出来的就是应该为nil
        let userAccountModel = NSKeyedUnarchiver.unarchiveObject(withFile: file) as?MJUserAccountModel
        
        return userAccountModel
    }
}

//OAuth界面请求数据
extension MJOAuthViewModel {
    
    //请求获取accessToken
    func getUserAccount(code :String,isFinish:@escaping (Bool )->()){
        
        MJNetworkTool.shared.loadUserAccount(code: code, success: { (response) in
            
            // 判断response 是否为nil 而且是否是一个字典
            // if-let 或者guard-let 做类型转换的时候 使用as?
            guard let res = response as? [String :Any?] else{
                //执行闭包
                isFinish(false)
                return
            }
            //字典转模型
            // 字典转模型
            let userAccountModel = MJUserAccountModel.yy_model(withJSON: res)
            
            // 判断是否为nil
            guard let u = userAccountModel else {
                //执行闭包
                isFinish(false)
                return
            }
            
            //请求个人信息数据
            self.getUserInfo(userAccountModel: u, isFinish: isFinish)
        }, failure: {(error)->() in
            
            print("失败",error)
            //执行闭包
            isFinish(false)
        })
    }
    
    //获取用户信息
    func getUserInfo(userAccountModel: MJUserAccountModel,isFinish:@escaping (Bool )->()){
        
       MJNetworkTool.shared.loadUserInfo(userAccountModel: userAccountModel, success: { (response)->() in
        
            //判断response 是否为nil ,且是否可以转换成字典
            guard let res = response as?[String :Any?] else{
                //执行闭包
                isFinish(false)
                return
            }
            //赋值
            userAccountModel.screen_name = res["screen_name"] as? String
            userAccountModel.avatar_large = res["avatar_large"]as? String
            
            //保存用户数据
            self.saveUserAccountModel(userAccountModel: userAccountModel)
            
            //最后终于成功了
            isFinish(true)
        }, failure: {(error)->()in
            print("失败",error)
            //执行闭包
            isFinish(false)
        })
    }
}
