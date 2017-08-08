//
//  MJNetworkTool.swift
//  我的Swift网络封装
//
//  Created by Michael 柏 on 2017/1/19.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import AFNetworking

// 请求方式的枚举(可以支持字符串的类型)
enum MJNetworkToolMethod:String {
    case get = "get"
    case post = "post"
}

class MJNetworkTool: AFHTTPSessionManager {

    //全局访问点
    static let shared:MJNetworkTool = {
        
        let tools = MJNetworkTool()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
       return tools
    }()
    
    //网络请求的公共方法
    /// - Parameters:
    ///   - method: 请求方式
    ///   - urlString: 请求url
    ///   - parameters: 请求参数
    ///   - success: 成功的闭包
    ///   - failure: 失败的闭包
    func request(method: MJNetworkToolMethod, urlString: String, parameters: Any?, success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        // 如果是get请求
        if method == .get {
            
            self.get(urlString, parameters: parameters, progress: nil, success: { (_, res) in
                // 执行闭包
                success(res)
            }, failure: { (_, err) in
                // 执行闭包
                failure(err)
            })
        }else {
            // post 请求
            self.post(urlString, parameters: parameters, progress: nil, success: { (_, res) in
                // 执行闭包
                success(res)
            }, failure: { (_, err) in
                // 执行闭包
                failure(err)
            })
        }
    }
}

//MARK: - 发布微博(文字微博&图片微博)
extension MJNetworkTool{
    
    //发布文字微博
    func update(status: String, success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        
        let urlString = "https://api.weibo.com/2/statuses/update.json"

        let params:[String: Any] = [
            "access_token": MJOAuthViewModel.shared.accessToken!,
            "status":status
        ]
    
        request(method: MJNetworkToolMethod.post, urlString: urlString, parameters: params, success: success, failure: failure)
    }
    
    //发布图片微博
    func upload(status: String,images:[UIImage], success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        
        let url = "https://upload.api.weibo.com/2/statuses/upload.json"
        let params:[String: Any] = [
            "access_token": MJOAuthViewModel.shared.accessToken!,
            "status":status
        ]
        
        /*
         - 参数01 上传的二进制文件
         - 参数02 服务器指定的名字 pic  mp4 mp3 区分客户端上传的是什么文件描述
         - 参数03 文件路径名字 一般可以随意些 及时你写了 服务器也不用
         - 参数04 告知服务器我们上传的文件的类型 一般可以传入application/octet-stream
         */
        
        // 通过图片转二进制
        //self.composePictureView.images
        post(url, parameters: params, constructingBodyWith: { (formdata) in
            let data = UIImagePNGRepresentation(images.first!)!
            
            formdata.appendPart(withFileData: data, name: "pic", fileName: "abc", mimeType: "application/octet-stream")
            
            //            // 如果一次发布9张图片怎么办 -> 通过循环方式上传
            //            for image in self.composePictureView.images {
            //                let data = UIImagePNGRepresentation(image)!
            //                formdata.appendPart(withFileData: data, name: "pic", fileName: "xxxx", mimeType: "application/octet-stream")
            //            }
        }, progress: nil, success: { (_, res) in
            success(res)
            
        }) { (_, err) in
            
            failure(err)
        }
    }
}


//MARK: - 请求微博首页数据
extension MJNetworkTool {
    // 请求微博首页数据
    func loadHomeData(since_id:Int64, max_id:Int64,success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        // 请求url
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        // 请求参数
        let params = [
            "access_token": MJOAuthViewModel.shared.accessToken!,
            "since_id": "\(since_id)",
            "max_id": "\(max_id)"

        ]
        // 发送请求
        request(method: MJNetworkToolMethod.get, urlString: urlString, parameters: params, success: success, failure: failure)
    }
}

//MARK: - 请求微博消息页数据
extension MJNetworkTool {
    
     // 请求微博消息页数据
    func loadMessageData(since_id:Int, max_id:Int64,success:@escaping (Any?)->(), failure:@escaping(Error)->()) {
        
        //请求url
        
        
        
        
    }
}


//MARK: - OAuth网络请求
extension MJNetworkTool{
    //请求获取accessToken
    func loadUserAccount(code :String,success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        
        //请求的url
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        //请求的参数
        let parameters =  [
            
            "client_id": APPKEY,
            "client_secret": APPSECRET,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": REDIRECT_URI
        ]

        //发送请求
        request(method: .post, urlString: urlStr, parameters: parameters, success: success, failure: failure)
    }
    
    //获取用户信息数据
    func loadUserInfo(userAccountModel: MJUserAccountModel,success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        
        // 请求的url
        let urlString = "https://api.weibo.com/2/users/show.json"
        // 请求的参数
        let params = [
            "access_token":userAccountModel.access_token!,
            "uid": userAccountModel.uid!
        ]
 
        //发送请求
        request(method: MJNetworkToolMethod.get, urlString: urlString, parameters: params, success: success, failure: failure)
    }
}











