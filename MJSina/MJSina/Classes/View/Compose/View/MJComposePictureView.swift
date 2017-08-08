//
//  MJComposePictureView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

//可重用的标志符
private let pictureViewCellId = "pictureViewCellId"

class MJComposePictureView: UICollectionView {
    
    var images:[UIImage] = [UIImage]()
    
    //定义一个闭包++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var closure:(()->())?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 定义一个layout
        let flowLayout = UICollectionViewFlowLayout()
        
        let itemWH = (MJSCREENW - 20 - 10)/3
        
        flowLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 供外界调用的方法
    func addImage(image: UIImage){
        
        //显示配图
        isHidden = false
//        01添加到数组中
        images.insert(image, at: 0)
        
        //如果images.count > 9 以后 移除最后面的
        if images.count > 9 {
            images.removeLast()
        }
        //02 刷新UI
        reloadData()
    }
    
    //MARK: - 设置视图
    private func setupUI(){

        // 默认配图是隐藏
        isHidden = true
        backgroundColor = UIColor.white
        //设置数据源,代理
        dataSource = self
        delegate = self
        //注册
        register(MJComposePictureViewCell.self, forCellWithReuseIdentifier: pictureViewCellId)
    }
}


extension MJComposePictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
         - 如果你有一张图片 那么cell 要显示两个 image.count + 1
         - 如果你有0张图片或者是9张图片 要显示实际 image.count
         */
        // 计算images元素的个数
        let count = images.count
        // 如果你有0张图片或者是9张图片 要显示实际 image.count
        if count == 0 || count == 9 {
            return count
        }else {
            
            return count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureViewCellId, for: indexPath) as! MJComposePictureViewCell
        /*
         - 假设 images.count = 3
         -numberOfItemsInSection 返回的是4
         - indexPath.item 都可以等于多少 0 1 2 3 (如果是3的话 显示的加号按钮)
         - 数组的images.count = 3  0 1 2
         */
        // 赋值
        
        // 是加号按钮
        if  indexPath.item == images.count {
            
            cell.image = nil
        
        }else{
            
            cell.image = images[indexPath.item]
        }
        
        //02 - 实例化闭包-----------------------------------------------------
        cell.closure = {[weak self] in
            //04-回调--------------------------------------------------------
            self?.images.remove(at: indexPath.item)
            //判断如果images.count == 0 隐藏
            if self?.images.count == 0 {
                self?.isHidden = true
            }
            //刷新UI
            self?.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //03 执行闭包++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //判断是最后一个是加号按钮才执行闭包
        if indexPath.item == images.count {
            closure?()
        }
    }
}

//自定义cell MJComposePictureViewCell
class MJComposePictureViewCell: UICollectionViewCell {
    
    //提供一个属性攻外界赋值
    var image:UIImage?{
        didSet{
            if image == nil {
                bgImageView.image = UIImage(named: "compose_pic_add")
                bgImageView.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
                deleBtn.isHidden = true
            }else{
                
                bgImageView.image = image
                // 解决复用问题
                bgImageView.highlightedImage = nil
                // 显示删除按钮
                deleBtn.isHidden = false
                
            }
        }
    }
    //定义一个闭包  告知父类干掉images的里面的对应的元素----------------------------
    var closure:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 监听事件
    @objc func buttonClick(){
        //03 执行闭包---------------------------------------------------------
        closure?()
    }

    private func setupUI(){

        contentView.addSubview(bgImageView)
        contentView.addSubview(deleBtn)
        
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        deleBtn.snp_makeConstraints { (make) in
            make.top.right.equalTo(contentView)
        }
    }
    
//MARK: - 懒加载控件
private lazy var bgImageView: UIImageView = UIImageView()

private lazy var deleBtn:UIButton = {
    
    let button = UIButton()
    
    button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
    button.setImage(UIImage(named:"compose_photo_close"), for: UIControlState.normal)
    
    return button
  }()

}



