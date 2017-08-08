//
//  MJHomeController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/1/16.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
// cell 可重用标示符
private let homeCellId = "homeCellId"

class MJHomeController: MJVisitorViewController {
    
    // 创建homeViewModel对象
    lazy var homeViewModel: MJHomeViewModel = MJHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置访客视图的信息
        if !isLogin {
            
            visitorView?.setupVistorViewInfo(title: nil, imgName: nil)
            return
        }
        setupUI()
        loadData()
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        //添加控件
        navigationController!.view.insertSubview(pullDownTipLabel, belowSubview: navigationController!.navigationBar)
        setupNav()
        setupTableViewInfo()
    }
    
    //MARK: - 设置导航
    private func setupNav(){
        // 左侧
        navigationItem.leftBarButtonItem =  UIBarButtonItem(imgName: "navigationbar_friendsearch", target: self, action: #selector(leftClick))
        // 右侧
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: "navigationbar_pop", target: self, action: #selector(rightClick))
    }
    
    
    
    
    //MARK: -设置tableView 相关信息
    private func setupTableViewInfo(){
        // 设置数据源代理
        tableView.dataSource = self
        tableView.delegate = self
        // 注册cell
        tableView.register(MJHomeCell.self, forCellReuseIdentifier: homeCellId)
        // 设置行高 -> 设置自动计算行高UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高(预估行高越接近于真实高度越好)
        tableView.estimatedRowHeight = 200
        //去掉tableView上 分割线
        tableView.separatorStyle = .none
        
        //添加到tableView上
        tableView.addSubview(refreshControl)
        //监听事件
        refreshControl.addTarget(self, action: #selector(refreshAction), for: UIControlEvents.valueChanged)
        
        //设置footView
        tableView.tableFooterView = footView
        
    }
    
    //MARK: - 懒加载控件
    //风火轮
    fileprivate lazy var footView: UIActivityIndicatorView = {
        
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        //设置颜色
        view.color = MJThemeColor
        return view
        
    }()
    
    //系统刷新控件
    fileprivate lazy var refreshControl: MJRefreshControl = MJRefreshControl()
    
    //下拉刷新只是Label
    fileprivate lazy var pullDownTipLabel: UILabel = {
        
        let lab = UILabel(fontSize: MJNORMALFONTSIZE, textColor: UIColor.white)
        lab.frame = CGRect(x: 0, y: 64 - 35, width: MJSCREENW, height: 35)
        lab.textAlignment = .center
        lab.backgroundColor = MJThemeColor
        lab.isHidden = true
        return lab
    }()
    
}


//MARK: -UITableViewDataSource
extension MJHomeController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellId, for: indexPath) as! MJHomeCell
        // 赋值
        cell.statusViewModel = homeViewModel.dataArray[indexPath.row]
        return cell
    }
    
    //将要显示的那个cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //最后一行才开始动画 ,而且风火轮没有开启动画
        if indexPath.row == homeViewModel.dataArray.count - 1 && !footView.isAnimating {
            footView.startAnimating()
            //开始请求
            loadData()
        }
    }
}

//MARK: -请求首页数据
extension MJHomeController {
    // 请求首页数据
    func loadData(){
        
        // 使用homeViewModel 请求数据
        
        homeViewModel.getHomeData(isPullUp: footView.isAnimating) { (isFinish, count) in
        
        // 在风火轮没有动画的时候 就代表是下拉刷新 才执行lable的动画
            if !self.footView.isAnimating{
                self.setupPullDownTipLabelAnim(count: count)
            }
            self.endRefreshing()
            
        // 如果失败了
            if !isFinish {
                
                return
            }else {
                // 请求成功 -> 刷新UI
                self.tableView.reloadData()
                
            }
        }
    }
    
    ///设置下拉刷新指示Label的动画
    func setupPullDownTipLabelAnim(count : Int){
        //判断如果你对额label在显示 ,就说明在执行动画,就能不用执行动画了
        if !self.pullDownTipLabel.isHidden {
            return
        }
        
        //label显示的内容
        var text = ""
        if count <= 0 {
            text = "已经是最新的微博啦!"
        }else{
         text = "更新了\(count)条微博"
        }
        
        //赋值
        self.pullDownTipLabel.text = text
        self.pullDownTipLabel.isHidden = false
        //设置pullDownTipLabel的动画
        UIView.animate(withDuration: 1, animations: { 
            self.pullDownTipLabel.transform = CGAffineTransform(translationX: 0, y: 35)
            
        }) { (_) in
            
            UIView.animate(withDuration: 1, delay: 2, options: [], animations: { 
                self.pullDownTipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.pullDownTipLabel.isHidden = true
            })
        }
 
    }
    
    
    
    // 结束动画方法
    func endRefreshing(){
        
        //停止系统刷新控件动画
        self.refreshControl.endRefreshing()
        self.footView.stopAnimating()
    }
    
    
}

//MARK: - 监听事件
extension MJHomeController{
    /*
     private 私有的在自己类内部使用没有问题 但是 如果吧方法放到其类的extension 就会找不到该方法 需要使用fileprivate 来修饰
     */
    // 左侧按钮点击
    @objc fileprivate func leftClick(){
        
    }
    // 右侧按钮点击
    @objc fileprivate func rightClick(){
        
        let tempVc = MJTempViewController()
        navigationController?.pushViewController(tempVc, animated: true)
    }
    
    //监听首页下拉刷新事件
    @objc fileprivate func refreshAction(){
        
        //请求数据
        loadData()
        
    }
    
    
}

