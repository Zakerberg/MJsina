//
//  MJRefreshControl.swift
//  我的下拉刷新
//
//  Created by Michael 柏 on 2017/2/7.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit

private let MJRefreshControlH: CGFloat = 50

enum MJRefreshControlType: String{
    
    case normal = "下拉刷新"
    case pulling = "释放更新"
    case refreshing = "加载中"
    
}

class MJRefreshControl: UIControl {
    
    var scrollView: UIScrollView?
    
    var refreshType: MJRefreshControlType = .normal{
        didSet{
            messageLabel.text = refreshType.rawValue
            switch refreshType {
            case .normal:
                UIView.animate(withDuration: 0.25, animations: {
                    self.pullRefreshImageView.transform = CGAffineTransform.identity
                })
                
                
                if oldValue == .refreshing {
                    UIView.animate(withDuration: 0.25, animations: {
                        
                        self.scrollView!.contentInset.top = self.scrollView!.contentInset.top - MJRefreshControlH
                    },completion: { (_) in
                        self.indicatorView.stopAnimating()
                        self.pullRefreshImageView.isHidden = false
                    })
                }
                
            case .pulling:
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.pullRefreshImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-3 * Double.pi))
                })
                
            case .refreshing:
                UIView.animate(withDuration: 0.25, animations: {
                    self.scrollView!.contentInset.top = self
                        .scrollView!.contentInset.top + MJRefreshControlH
                    
                    self.indicatorView.startAnimating()
                    self.pullRefreshImageView.isHidden = true
                    
                }, completion: { (_) in
                    self.sendActions(for: UIControlEvents.valueChanged)
                    
                })
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -MJRefreshControlH, width: UIScreen.main.bounds.width, height: MJRefreshControlH))
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func endRefreshing(){
        refreshType = .normal
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        guard let scrollerView = newSuperview as? UIScrollView   else {
            return
        }
        
        self.scrollView = scrollerView
        
        scrollerView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
        override func observeValue(forKeyPath: String?, of: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
            
            
            let maxY = self.scrollView!.contentInset.top + MJRefreshControlH
            let contenOffSetY = self.scrollView!.contentOffset.y
            
            if self.scrollView!.isDragging {
                
                if contenOffSetY >= -maxY && refreshType == .pulling {
                    
                    refreshType = .normal
                    
                }else if contenOffSetY < -maxY && refreshType == .normal {
                    
                    refreshType = .pulling
                }
                
            }else {
                if refreshType == .pulling {
                    
                    refreshType = .refreshing
                }
                
            }

        }
    
    
    private func setupUI(){
        
        backgroundColor = UIColor.orange
        
        addSubview(messageLabel)
        addSubview(pullRefreshImageView)
        addSubview(indicatorView)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        pullRefreshImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: pullRefreshImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: pullRefreshImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    }
    
    
    private lazy var messageLabel: UILabel = { 
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = UIColor.white
        lab.text = "释放更新"
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    private lazy var pullRefreshImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    deinit {
        self.scrollView!.removeObserver(self, forKeyPath: "contentOffset")
    }
}
