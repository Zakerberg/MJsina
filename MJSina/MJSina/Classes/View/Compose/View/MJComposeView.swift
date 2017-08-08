//
//  MJComposeView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import pop

class MJComposeView: UIView {
    
    //保存6 个按钮的数组
    var composeButtonsArray:[MJComposeButton] = [MJComposeButton]()
 
    // 记录hmmainvc
    var target: UIViewController?
   
  override init(frame: CGRect) {
        super.init(frame: frame)
         setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 ///MARK: - 供外界调用的方法 
    func show(target: UIViewController){
        
        self.target = target
        
        //添加composeView -> mjmain.vc.view
        target.view.addSubview(self)
        //设置6个按钮的动画
        setupComposeButtonAnim(isUp: true)
        
    }
    
     ///MARK: - 设置6个按钮的动画
    func setupComposeButtonAnim(isUp: Bool){
        
        // 默认动画使用高度临界值
        var H:CGFloat = 350
        
        if !isUp {
            composeButtonsArray.reverse()
            H = -350
        }
        
        // 遍历保存按钮的数组 分别给六个按钮设置动画
        for (i, button) in composeButtonsArray.enumerated() {
            //实例化阻尼动画对象
            let anSpring = POPSpringAnimation(propertyNamed: kPOPViewCenter)!
//            设置最终点
            anSpring.toValue = CGPoint(x: button.center.x, y: button.center.y - H)
            // 开始时间 CACurrentMediaTime() 系统绝对时间
            anSpring.beginTime = CACurrentMediaTime() + Double(i)*0.025
            
            //[0-20] 弹力 越大则震动幅度越大
            anSpring.springBounciness = 4
            //[0-20] 速度 越大则动画结束越快
            anSpring.springSpeed = 12
            // 给button按钮添加动画
            button.pop_add(anSpring, forKey: nil)
            
        }
    }
    
    ///MARK:- 设置视图
  private func setupUI(){
    
    self.frame.size = CGSize(width: MJSCREENW, height: MJSCREENH)

    addSubview(bgImageView)
    addSubview(logoImageView)
    addSubview(bottomView)
    bottomView.addSubview(bottomImageBtn)
    
    bgImageView.snp_makeConstraints { (make) in
        make.edges.equalTo(self)
    }
    
    logoImageView.snp_makeConstraints { (make) in
        make.centerX.equalTo(self)
        make.top.equalTo(self).offset(100)
    }
    
    bottomView.snp_makeConstraints { (make) in
        make.left.right.bottom.equalTo(self)
        make.height.equalTo(40)
    }
    
    bottomImageBtn.snp_makeConstraints { (make) in
        make.center.equalTo(bottomView)
    }
    creatChildBtn()
        
}
    ///MARK : - 创建6个按钮
    private func creatChildBtn(){
        // 得到数组
        let composeModelArray = loadPlist()
        
        // 抽取按钮的宽和高度
        let buttonW: CGFloat = 80
        let buttonH: CGFloat = 110
        // 计算间距
        let buttonMargin = (MJSCREENW - buttonW*3)/4
        
        // 遍历数组
        for (i, composeModel) in composeModelArray.enumerated() {
            // 实例化button
            let button =  MJComposeButton()
            // 设置model
            button.composeModel = composeModel
            // 添加点击事件
            button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
            // 设置size
            button.frame.size = CGSize(width: buttonW, height: buttonH)
            
            // 计算列和行的索引
            let colIndex = CGFloat(i%3)
            let rowIndex = CGFloat(i/3)
            // 设置x&y轴
            button.frame.origin.x = buttonMargin + colIndex*(buttonW + buttonMargin)
            button.frame.origin.y = rowIndex*(buttonH + buttonMargin) + MJSCREENH
            // 设置image
            button.setImage(UIImage(named: composeModel.icon ?? ""), for: UIControlState.normal)
            button.setTitle(composeModel.title, for: UIControlState.normal)
            addSubview(button)
            // 添加六个按钮
            composeButtonsArray.append(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.bottomImageBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI)/2)
            
        }, completion: { (_) in
            self.setupComposeButtonAnim(isUp: false)
            
            //延迟移除当前的View
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.removeFromSuperview()
            }
        })
    }
    
    //MARK:- 懒加载控件
    // 背景图片
    private lazy var bgImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.screenShot()!.applyLightEffect()
        return img
 
    }()
    
    private lazy var logoImageView: UIImageView = UIImageView(imgName: "compose_slogan")
    
    private lazy var bottomView: UIImageView = {
        
        let bottomImgView = UIImageView()
        
        bottomImgView.backgroundColor = UIColor.white
        
        bottomImgView.isUserInteractionEnabled = true
        
        return bottomImgView
    }()
    
    
    fileprivate lazy var bottomImageBtn: UIButton = {
        let bottomBtn = UIButton()
        bottomBtn.setImage(UIImage(named:"cancel"), for: UIControlState.normal)
        bottomBtn.setImage(UIImage(named:"cancel1"), for: UIControlState.highlighted)
        
        bottomBtn.addTarget(self, action: #selector(bottomCancelClick), for: UIControlEvents.touchUpInside)
        
        return bottomBtn
    }()
}

extension MJComposeView {
    @objc fileprivate func bottomCancelClick() {
        
        
        UIView.animate(withDuration: 0.25, animations: {

            self.bottomImageBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI)/2)
            
        }, completion: { (_) in
            self.setupComposeButtonAnim(isUp: false)
            
            //延迟移除当前的View
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.removeFromSuperview()
            }
        })
    }
    
    func buttonClick(btn: MJComposeButton) {
        // 设置按钮放大和缩小动画
        UIView.animate(withDuration: 0.25, animations: {
            // 遍历6个按钮的数组
            for button in self.composeButtonsArray {
                // 透明度设置为0.2
                button.alpha = 0.2
                // 判断是否是点击的按钮
                if btn == button {
                    // 放大操作
                    button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }else {
                    // 缩小操作
                    button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            }
            
        }, completion: { (_) in
            
            UIView.animate(withDuration: 0.25, animations: {
                
                // 遍历6个按钮数组
                for button in self.composeButtonsArray {
                    // 透明度设置为1
                    button.alpha = 1
                    //把所有按钮的状态恢复为原样
                    button.transform = CGAffineTransform.identity
                }
                
            }, completion: { (_) in
                
                /*
                 - 命名空间 指得的就是项目的名称
                 - 在OC中没有命名空间 也就是说所有的类可以通过字符串转class
                 - 在Swift 中 系统提供的类可以通过字符串转class
                 - 但是程序员自定义的类需要使用命名空间.自定义类名 才可以完成字符串转class
                 */
                // 通过模型中的classname 得到对应的class
                let c = NSClassFromString(btn.composeModel?.classname ?? "")! as! UIViewController.Type
                // 通过class 实例化一个控制器的对象
                let vc = c.init()
                // 导航控制器
                let composeNav = MJNavController(rootViewController: vc)
                // 模态
                self.target?.present(composeNav, animated: true, completion: {
                // 移除当前的视图
                self.removeFromSuperview()
            
                })
            })
        })
    }
}
//    加载plist文件
extension MJComposeView {
    
        func loadPlist() -> [MJComposeModel]{
            
            let file = Bundle.main.path(forResource: "compose.plist", ofType: nil)!
            
            let plistArray = NSArray(contentsOfFile: file)!
            
            let tempArray = NSArray.yy_modelArray(with: MJComposeModel.self, json: plistArray) as! [MJComposeModel]
            
            return tempArray
    }
}
    
    

    
    
    
    
