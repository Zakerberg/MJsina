//
//  MJComposeViewController.swift
//  MJSina
//
//  Created by Michael 柏 on 2017/2/8.
//  Copyright © 2017年 Michael Bai. All rights reserved.
//

import UIKit
import AFNetworking

class MJComposeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - 设置视图
    private func setupUI(){
        view.backgroundColor = MJRandomColor()
        setupNav()
        // 添加控件
        view.addSubview(composeTextView)
        composeTextView.addSubview(composePictureView)
        view.addSubview(composeBottomView)
        // 添加约束
        composeTextView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        composePictureView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: MJSCREENW - 20, height: MJSCREENW - 20))
            make.top.equalTo(composeTextView).offset(100)
            make.centerX.equalTo(composeTextView)
        }
        
        composeBottomView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(40)
        }
        
        // 02 闭包实例化 监听底部视图的按钮点击
        composeBottomView.closure = {[weak self](type)->() in
            // 04 回调
            switch type {
            case .picture:
                print("图片")
                self?.selectImage()
            case .mention:
                print("@")
            case .trend:
                print("#")
            case .emoticon:
                print("笑脸")
                // 切换键盘
                self?.switchKeyboard()
                
            case .add:
                print("+")
            }
            
        }
        // 02 监听配图中加号按钮点击++++++++++++++++++++++++++++++++++
        composePictureView.closure = {[weak self]()->() in
            // 调用选择图片方法
            // 04 回调++++++++++++++++++++++++++++++++++++++++++++++
            self?.selectImage()
        }
        
        // 监听键盘将要改变frame通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // 监听表情键盘的表情按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(emoticonButtonNoti), name: NSNotification.Name(rawValue: EMOTICONBUTTONNOTI), object: nil)
        // 监听表情键盘删除按钮点击
        NotificationCenter.default.addObserver(self, selector: #selector(emoticonDeleteButtonNoti), name: NSNotification.Name(rawValue: EMOTICONDELETEBUTTONNOTI), object: nil)
    }
    
    //MARK: - 设置导航
    private func setupNav(){
        // 左右侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: nil, title: "取消", target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: nil, title: "发送", target: self, action: #selector(sendAction))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.titleView = titleView
    }
    
    //MARK: - 懒加载控件
    // titleView
    private lazy var titleView: UILabel = {
        // 获取微博用户的昵称
        let name = MJOAuthViewModel.shared.userAccountModel?.screen_name ?? ""
        // 设置发布微博最终显示的内容
        let str = "发微博\n\(name)"
        // 获取范围 -> OC
        let range = (str as NSString).range(of: name)
        // 可变富文本
        let attr = NSMutableAttributedString(string: str)
        // 设置富文本的属性 字体的颜色和字体的大小
        attr.addAttributes([NSForegroundColorAttributeName: MJThemeColor, NSFontAttributeName: UIFont.systemFont(ofSize: 12)], range: range)
        let lab = UILabel()
        // 设置text
        lab.attributedText = attr
        // 换行
        lab.numberOfLines = 0
        // 对齐方式
        lab.textAlignment = .center
        // 设置大小
        lab.sizeToFit()
        return lab
    }()
    // 自定义textView
    fileprivate lazy var composeTextView: MJComposeTextView = {
        let view = MJComposeTextView()
        // 设置占位文字
        view.placeholder = "设置占位文字设置占位文字设置占位文字设置占位文字设置占位文字设置占位文字设置占位文字"
        // 设置字体大小
        view.font = UIFont.systemFont(ofSize: MJNORMALFONTSIZE)
        // 设置代理
        view.delegate = self
        // 允许textView 垂直滚动
        view.alwaysBounceVertical = true
        return view
    }()
    // 底部视图
    fileprivate lazy var composeBottomView: MJComposeBottomView = MJComposeBottomView()
    // 配图
    fileprivate lazy var composePictureView: MJComposePictureView = MJComposePictureView()
    // 自定义表情键盘
    fileprivate lazy var emoticonKeyboardView: MJEmoticonKeyboardView = MJEmoticonKeyboardView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
//MARK: - 监听通知
extension MJComposeViewController {
    // 监听键盘的frame将要发生改变
    func keyboardWillChangeFrame(noti: Notification){
        // 判断userINfo是否为nil 是否可以转成字典
        guard let userInfo = noti.userInfo as?[String: Any] else{
            return
        }
        // 获取键盘的frame
        let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 获取键盘动画时间
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // 更改底部视图的bottom
        self.composeBottomView.snp_updateConstraints { (make) in
            make.bottom.equalTo(view).offset(frame.origin.y - MJSCREENH)
        }
        
        // 设置动画
        UIView.animate(withDuration: duration) {
            // 刷新ui
            self.view.layoutIfNeeded()
        }
    }
    // 监听表情键盘按钮点击
    func emoticonButtonNoti(noti: Notification){
        // 判断是否为nil 且是否可以转成HMEmoticonModel
        guard let emoticonModel = noti.object as? MJEmoticonModel  else {
            return
        }
        
        // 01 保存用户点击的那个表情的模型
        MJEmoticonTools.shared.saveRecentModel(emoticonModel: emoticonModel)
        // 刷新pageView
        self.emoticonKeyboardView.reloadRecentData()
        // 判断如果是emoji表情
        if emoticonModel.isEmoji {
            let code = ((emoticonModel.code ?? "") as NSString).emoji()
            self.composeTextView.insertText(code!)
        }else {
            
            // 获取当前composeTextView上的富文本
            let allAttr = NSMutableAttributedString(attributedString: self.composeTextView.attributedText)
            // 图片表情
            //            // 创建一个文本附件
            //            let att = NSTextAttachment()
            //            let path = emoticonModel.path ?? ""
            //            // 获取bundle文件中图片
            //            let image = UIImage(named: path, in: HMEmoticonTools.shared.emoticonBundle, compatibleWith: nil)
            //            // 设置image
            //            att.image = image
            //            // 得到行号
            //            let lineHeight = self.composeTextView.font!.lineHeight
            //            // bounds (给image 设置大小)
            //            att.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
            // 定义一个不可变的富文本
            let attr = NSAttributedString.emoticonAttributedString(emoticonModel: emoticonModel)
            //            // 拼接上
            //            allAttr.append(attr)
            // 获取当前composeText 的selectRange (光标)
            let selectRange = self.composeTextView.selectedRange
            //            // 插入
            //            allAttr.insert(attr, at: selectRange.location)
            // 替换
            allAttr.replaceCharacters(in: selectRange, with: attr)
            // 范围
            let range = NSRange(location: 0, length: allAttr.length)
            // 设置字体大小
            allAttr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: MJNORMALFONTSIZE)], range: range)
            // 设置富文本给textView
            self.composeTextView.attributedText = allAttr
            // 重新设置他的光标位置
            self.composeTextView.selectedRange = NSRange(location: selectRange.location + 1, length: 0)
            
            // 要把composeTextView 的占位文字隐藏
            // 帮系统发送一个通知
            NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: nil)
            // 要把导航栏右侧的按钮修改状态
            // 使用代理调用协议方法
            self.composeTextView.delegate?.textViewDidChange!(self.composeTextView)
        }
        
        
    }
    // 监听删除按钮点击
    func emoticonDeleteButtonNoti(){
        // 删除
        self.composeTextView.deleteBackward()
    }
}


//MARK: - 监听HMComposeBottomView 中按钮的事件
extension MJComposeViewController{
    // 从相册选择图片
    func selectImage() {
        // 实例化
        let pickerVc = UIImagePickerController()
        // 设置代理
        pickerVc.delegate = self
        // 打开相册
        self.present(pickerVc, animated: true, completion: nil)
    }
    
    // 切换键盘
    func switchKeyboard(){
        // 如果inputView == nil 就代表是系统键盘 改成自定义键盘
        if self.composeTextView.inputView == nil {
            self.composeTextView.inputView = self.emoticonKeyboardView
            // 改成true
            self.composeBottomView.isEmoticon = true
        }else {
            // 如果inputView != nil 就代表你设置了自定义键盘 改成系统键盘
            self.composeTextView.inputView = nil
            // 改成false
            self.composeBottomView.isEmoticon = false
        }
        // 开启第一响应
        self.composeTextView.becomeFirstResponder()
        
        // 刷新
        self.composeTextView.reloadInputViews()
    }
}
//MARK: - UIImagePickerControllerDelegate
extension MJComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // 获取内容
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 吧image 传给composePictrueView
        self.composePictureView.addImage(image: image.dealImageScale(width: 400))
        
        // 关闭控制器
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 图片压缩策略 等比例压缩
    // 如果宽度大于400(width) 就需要压缩处理
    func dealImageScale(image: UIImage, width: CGFloat) -> UIImage{
        // 如果image 的宽度小于等于400 直接返回
        if image.size.width <= width {
            return image
        }
        // 比例结果
        // 比例后的高度
        let h = width*image.size.height/image.size.width
        // 01 开启上下文
        UIGraphicsBeginImageContext(CGSize(width: width, height: h))
        // 02 吧image 渲染到上下文中
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: h))
        // 03 从上下文中获取image
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 04 关闭上下文
        UIGraphicsEndImageContext()
        // 05 返回image
        return image
    }
}

//MARK: - UITextViewDelegate
extension MJComposeViewController:UITextViewDelegate {
    // 文字发生改变
    func textViewDidChange(_ textView: UITextView) {
        // 使右侧按钮不能点击
        self.navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 取消第一响应
        self.composeTextView.resignFirstResponder()
    }
}

//MARK: - 监听方法
extension MJComposeViewController {
    // 关闭
    @objc fileprivate func cancelAction(){
        // 关闭控制器
        dismiss(animated: true, completion: nil)
    }
    // 发送
    @objc fileprivate func sendAction(){
        print("发送按钮点击啦")
        
        // A图片a  -> A[马到成功]a
        //        print(composeTextView.attributedText)
        
        let range = NSRange(location: 0, length: composeTextView.attributedText.length)
        // 定义一个字符串 做拼接
        var allText = ""
        // 枚举遍历
        composeTextView.attributedText.enumerateAttributes(in: range, options: []) { (info, range, _) in
            // 文本附件
            if let att = info["NSAttachment"] as? MJTextAttachment {
                allText += (att.emoticionModel?.chs ?? "")
            }else{
                // 普通字符串
                allText += composeTextView.attributedText.attributedSubstring(from: range).string
            }
        }
        
        // 判断是文字微博还是图片微博
        if self.composePictureView.images.count > 0 {
            // 图片微博
            upload(status: allText)
        }else {
            // 文字微博
            update(status: allText)
        }
    }
}

//MARK: - 发布微博(文字微博&图片微博)
extension MJComposeViewController{
    // 发布文字微博
    func update(status: String){
        
        MJNetworkTool.shared.update(status: status, success: { (res) in
            print("发送成功")
        }, failure: { (err) in
            print("发送失败",err)
        })
        
    }
    // 发布图片微博
    func upload(status: String){
        
        MJNetworkTool.shared.upload(status: status, images: self.composePictureView.images, success: { (res) in
            print("成功")
        }, failure: { (err) in
            print("失败",err)
        })
        
    }
}
