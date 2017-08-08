//
//  MJHomePictureView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/5.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import SDWebImage
/*
 - 配图控件
 - 配图的size 是 pic_urls.count 来决定的
 */
// cell 可重用标识符
private let pictureViewCellId = "pictureViewCellId"
// 各张图片之间的间距
private let itemMargin: CGFloat = 5
// 获取每张图片的宽高(正方形)
private let itemWH: CGFloat = (MJSCREENW - 2*10 - 2*itemMargin)/3
class MJHomePictureView: UICollectionView {
    
    
    // 定义一个属性供外界赋值
    var pic_urls: [MJPictureModel]?{
        didSet{
            // 获取配图的size
            let size = dealPictureViewSize(count: pic_urls?.count ?? 0)
            
            // 设置约束
            self.snp_updateConstraints { (make) in
                make.size.equalTo(size)
            }
            
            
            // 获取到layout
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            
            // 如果是单张图片
            if pic_urls?.count == 1 {
                layout.itemSize = size
            }else {
                // 多张图片
                layout.itemSize = CGSize(width: itemWH, height: itemWH)
            }
            
            // 因为itemSize的宽度和配图的宽度没有同步导致打印错误 需要解决该问题 需要重新刷新ui
            layoutIfNeeded()
            // 刷新UI
            reloadData()
        }
    }
    
    // 通过图片的张数来计算配图的size
    func dealPictureViewSize(count: Int) -> CGSize{
        // 如果是单张图片
        if count == 1 {
            // 判断图片地址是否为nil
            if let picUrlString = pic_urls?.first?.thumbnail_pic {
                // 在本地拿到我们下载下来的网络图片
                if let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrlString) {
                    
                    // 的到本地图片的大小
                    var w = image.size.width
                    var h = image.size.height
                    
                    // 如果宽度小于80 默认为80
                    if w < 80 {
                        w = 80
                    }
                    
                    // 如果高度大于150 默认为150
                    if h > 150 {
                        h = 150
                    }
                    
                    // 最终的大小
                    return CGSize(width: w, height: h)
                }
            }
            
        }
        
        // 通过图片张数来计算 行数和列数
        let col = count == 4 ? 2 : count > 3 ? 3 : count
        let row = count == 4 ? 2 : (count - 1)/3 + 1
        
        // 计算配图的宽和高
        let w = CGFloat(col)*itemWH + CGFloat(col - 1)*itemMargin
        let h = CGFloat(row)*itemWH + CGFloat(row - 1)*itemMargin
        return CGSize(width: w, height: h)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 自定义layout
        let picLayout = UICollectionViewFlowLayout()
        // 设置itemSize
        picLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        // 设置行间距和列间距
        picLayout.minimumLineSpacing = itemMargin
        picLayout.minimumInteritemSpacing = itemMargin
        super.init(frame: frame, collectionViewLayout: picLayout)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        //        // 随机颜色
        //        backgroundColor = HMRandomColor()
        // 设置数据源代理
        dataSource = self
        // 注册cell
        register(HMHomePictureViewCell.self, forCellWithReuseIdentifier: pictureViewCellId)
    }
    
}
//MARK: - UICollectionViewDataSource
extension MJHomePictureView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pic_urls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureViewCellId, for: indexPath) as! HMHomePictureViewCell
        // 赋值
        cell.pic_url = pic_urls![indexPath.item]
        return cell
    }
}

//MARK: - 自定义HMHomePictureViewCell
class HMHomePictureViewCell: UICollectionViewCell {
    
    // 提供属性供外界赋值
    var pic_url: MJPictureModel?{
        
        didSet{
            // 赋值
            bgImageView.mj_setImage(urlString: pic_url?.thumbnail_pic)
            
            //判断是否是gif
            if let pic = pic_url?.thumbnail_pic,pic.hasSuffix("gif") {
                gifImageView.isHidden = false
            }else{
                gifImageView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        // 添加控件
        contentView.addSubview(bgImageView)
        contentView.addSubview(gifImageView)
        // 添加约束
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        gifImageView.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
        }
    }
    
    //MARK: - 懒加载控件
    // 背景图片
    private lazy var bgImageView: UIImageView = {
        let img = UIImageView(imgName: "avatar_default_big")
        // 设置iamge的填充模式
        img.contentMode = .scaleAspectFill
        // 超出的部分需要裁掉
        img.clipsToBounds = true
        return img
    }()
    
    private  lazy var gifImageView: UIImageView = UIImageView(imgName: "timeline_image_gif")
    

    
}









