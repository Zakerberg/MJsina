//
//  AppDelegate.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /*
         看oauthModel是否保存数据成功
         let oauthModel = MJOAuthViewModel()
         let u = oauthModel.gerUserAccountModel()
         print(u)
         */
        
        // 实例化
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // 设置背景颜色
        self.window?.backgroundColor = UIColor.white
        // 设置根控制器
        self.window?.rootViewController = setupRootViewController()
        // 成为主窗口并显示
        self.window?.makeKeyAndVisible()
        
        
        //注册通知 监听切换根控制器
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootViewController), name: NSNotification.Name(rawValue: SWITCHEROOTVIEWCONTROLLERNOTI), object: nil
        )
        return true
    }
    
    // 监听切换跟控制的方法
    /*
     - 访客视图->登录界面->欢迎界面 object = nil
     - 欢迎界面->首页 object = "welcomeVc"
     */
    @objc private func switchRootViewController (noti: Notification){
      window?.rootViewController = noti.object == nil ? MJWelcomeViewController():MJMainViewController()
    }
    
    
    /*
         - 程序启动的时候, 选择跟视图
           - 如果没有登录 rootVC = MJMainVC
           - 登录了   rotVC  = MJWelcomeVC
     */
    
    //设置根控制器
    private func setupRootViewController() -> UIViewController{
//        //如果没有登录
//        if !MJOAuthViewModel.shared.isLogin {
//            
//            return MJMainViewController()
//        }else{
//            return MJWelcomeViewController()
//        }
    
        return !MJOAuthViewModel.shared.isLogin == true ?
        MJMainViewController():MJWelcomeViewController()
    }
    
    //析构函数
    deinit {
        NotificationCenter.default.removeObserver(self) 
    }
    
}
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }




