//
//  MJEmoticonPageView.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/10.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

// cell 可重用标识符
private let pageViewCellId = "pageViewCellId"

class MJEmoticonPageView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置itemSize
        flowLayout.itemSize = CGSize(width: MJSCREENW, height: 216 - 35)
        // 设置滚动方向
        flowLayout.scrollDirection = .horizontal
        // 设置间距
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 设置视图
    private func setupUI(){
        //        backgroundColor = HMRandomColor()
        // 设置代理
        dataSource = self
        // 注册cell
        register(MJEmoticonPageViewCell.self, forCellWithReuseIdentifier: pageViewCellId)
    }
    
}

extension MJEmoticonPageView: UICollectionViewDataSource {
    
    // 分多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MJEmoticonTools.shared.allEmoticons.count
    }
    // 分多少页
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MJEmoticonTools.shared.allEmoticons[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pageViewCellId, for: indexPath) as! MJEmoticonPageViewCell
        cell.indexPath = indexPath
        // 赋值
        cell.emoticons = MJEmoticonTools.shared.allEmoticons[indexPath.section][indexPath.item]
        return cell
    }
}
