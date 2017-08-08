
//
//  MJEmoticonKeyboardView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/10.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

class MJEmoticonKeyboardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 刷新最近表情的UI
    func reloadRecentData(){
        // 第一组 第一页
        let indexPath = IndexPath(item: 0, section: 0)
        self.emoticonPageView.reloadItems(at: [indexPath])
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        // 设置大小
        self.frame.size = CGSize(width: MJSCREENW, height: 216)
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        
        // 添加控件
        addSubview(emoticonBottomView)
        addSubview(emoticonPageView)
        addSubview(pageControl)
        // 添加约束
        emoticonBottomView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(35)
        }
        
        emoticonPageView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(emoticonBottomView.snp_top)
        }
        
        pageControl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(emoticonPageView).offset(10)
        }
        
        // 因为当前滚动的时候pageView 还没有加载完成 所以无法看到效果 需要使用gcd 通过主线程异步才能解决该bug
        DispatchQueue.main.async {
            // 设置pageView 默认滚到第一组
            // indePath
            let indexPath = IndexPath(item: 0, section: 1)
            // pageView 滚动到指定的组
            self.emoticonPageView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            
            // 设置pageControl
            self.setupPageControl(indexPath: indexPath)
        }
        
        // 监听底部视图的点击
        emoticonBottomView.closure = {(type) -> () in
            
            switch type {
            case .recent:
                print("最近")
            case .normal:
                print("默认")
            case .emoji:
                print("emoji")
            case .xlh:
                print("浪小花")
                
            }
            
            // indePath
            let indexPath = IndexPath(item: 0, section: type.rawValue - 100)
            // pageView 滚动到指定的组
            self.emoticonPageView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            // 设置pageControl
            self.setupPageControl(indexPath: indexPath)
            
        }
    }
    //MARK: - 懒加载
    // 底部视图
    fileprivate lazy var emoticonBottomView: MJEmoticonBottomView = MJEmoticonBottomView()
    // 表情键盘使用的view
    fileprivate lazy var emoticonPageView: MJEmoticonPageView = {
        let view = MJEmoticonPageView()
        view.backgroundColor = self.backgroundColor
        // 设置代理
        view.delegate = self
        // 取消弹簧效果
        view.bounces = false
        // 设置分页
        view.isPagingEnabled = true
        // 取消滚动条
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    // 分页指示器
    fileprivate lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        // 设置总页数
        view.numberOfPages = 4
        // 当前页数
        view.currentPage = 1
        // 设置默认图片(KVC)
        view.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "pageImage")
        //        view.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        // 设置选中图片(KVC)
        view.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "currentPageImage")
        //        view.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        view.isUserInteractionEnabled = false
        // 如果UIPageControl 总页数为1的时候不显示
        view.hidesForSinglePage = true
        return view
    }()
    
}
//MARK: - UICollectionViewDelegate
extension MJEmoticonKeyboardView: UICollectionViewDelegate {
    // 实时监听pageView 滚动
    /*
     - 我们是不是要得到indexPath 的对应的section(0,1,2,3) 通过section 得到对应按钮的tag 得到按钮 设置他的选中状态
     - 必须先要拿到那个indePath显示在屏幕的中间点上
     - 要获取屏幕的中心点
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取中心点的x
        let centerX = MJSCREENW/2 + scrollView.contentOffset.x
        // 获取中心点的y
        let centerY = CGFloat((216 - 35)/2)
        // 获取center
        let center = CGPoint(x: centerX, y: centerY)
        // 获取屏幕中心点对应的indexPath
        if let indexPath = self.emoticonPageView.indexPathForItem(at: center){
            // 设置选中的按钮状态
            self.emoticonBottomView.setupSelectButton(tag: indexPath.section + 100)
            // 设置pageControl
            self.setupPageControl(indexPath: indexPath)
        }
    }
}

extension MJEmoticonKeyboardView{
    // 设置pagecntrol
    func setupPageControl(indexPath: IndexPath){
        // 设置pageControl
        self.pageControl.numberOfPages = MJEmoticonTools.shared.allEmoticons[indexPath.section].count
        self.pageControl.currentPage = indexPath.item
    }
}
