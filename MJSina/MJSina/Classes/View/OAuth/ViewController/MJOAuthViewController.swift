//
//  MJOAuthViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/17.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import YYModel
import SVProgressHUD

class MJOAuthViewController: UIViewController {

   override func loadView() {
    
    view = webView
    
    //urlString
     let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(APPKEY)&redirect_uri=\(REDIRECT_URI)"
    
    //实例化url
    let url = URL(string: urlString)
    guard let u = url else {
        return
    }
    //实例化request
    let request = URLRequest (url: u)
    
    //加载
    webView.loadRequest(request)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
   //MARK: - 设置视图
    private func setupUI(){
        view.backgroundColor = UIColor.white
        setupNav()
    }
    
    //MARK: - 设置导航
    private func setupNav(){
        
        title = "微博登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: nil, title: "取消", target: self, action: #selector(cancelClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: nil, title: "自动填充", target: self, action: #selector(autofillClick))

    }
    
//MARK: - 懒加载控件
    fileprivate lazy var webView :UIWebView = {
        
        let view = UIWebView()
        
        //设置代理
        view.delegate = self
        
        return view
        
    }()
}

extension MJOAuthViewController:UIWebViewDelegate {
    // 开始加载
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    // 加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    // webView 将要加载的请求 会走该方法 默认返回true 允许加载将要加载的请求
    // 默认如果不实现该代理方法 默认都是允许加载的
    // UIWebViewNavigationType
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 将要加载请求的字符串
        let urlString = request.url?.absoluteString
        // 判断urlString 是否为nil 且 字符串的前缀是回调页 前缀hasPrefix
        if let u = urlString, u.hasPrefix(REDIRECT_URI){
            // 请求参数部分 url?.query
            let query = request.url?.query
            // 判断query 是否为nil
            if let q = query {
                print(q)
                // 截取code
                let code = q.substring(from: "code=".endIndex)
                print("终于等到你",code)
                // 已经拿到code
                // 发送请求 获取accessToken
                MJOAuthViewModel.shared.getUserAccount(code: code, isFinish: { (isFinish) in
                    if !isFinish {
                        
                        return
                    }else {
                        
                        // 先要关闭当前控制器 然后发送通知
                        self.dismiss(animated: false, completion: {
                            // 发送通知告知appdelegate 切换根控制器
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue:SWITCHEROOTVIEWCONTROLLERNOTI), object: nil)
                        })
                        
                    }
                })
                return false
                
            }
            
        }
        return true
    }
}

//MARK:- 监听事件
extension MJOAuthViewController{
    
    //返回
    @objc fileprivate func cancelClick(){
        dismiss(animated: true, completion: nil)
    }
    //自动填充
    @objc fileprivate func autofillClick(){

        // js
        let jsString = "document.getElementById('userId').value='\(MJWBNAME)';document.getElementById('passwd').value='\(MJWBPASSWD)';"
        // js注入
        webView.stringByEvaluatingJavaScript(from: jsString)
        
    }
}





