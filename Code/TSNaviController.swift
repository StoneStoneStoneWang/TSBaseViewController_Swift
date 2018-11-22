//
//  TSNaviController.swift
//  TSBaseViewController_Swift
//
//  Created by three stone 王 on 2018/11/20.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import TSToolKit_Swift
class TSConfig_Swift: NSObject {
    
    static let shared = TSConfig_Swift()
    
    private override init() {
        
        guard let path = Bundle.main.path(forResource: "TSConfig_Swift", ofType: "plist") else { return }
        
        guard let json = NSDictionary(contentsOfFile: path) else { return }
        
        Back_Image = json["Back_Image"] as? String ?? ""
        
        Title_FontSize = CGFloat(Float(json["Title_FontSize"] as? String ?? "") ?? 0)
        
        Title_HEXColor = json["Title_HEXColor"] as? String ?? ""
        
        Background_HEXColor = json["Background_HEXColor"] as? String ?? ""
        
        NaviBackground_HEXColor = json["NaviBackground_HEXColor"] as? String ?? ""
    }
    // 返回按钮
    var Back_Image: String = ""
    //  标题字体
    var Title_FontSize: CGFloat = 0
    // 标题颜色
    var Title_HEXColor: String = ""
    // root vc 背景色
    var Background_HEXColor: String = ""
    // 导航背景色
    var NaviBackground_HEXColor: String = ""
}

public enum TSNaviTransionType {
    case push
    
    case present
}

open class TSNaviController: UINavigationController {
    
    open var navBarHairlineImageView: UIImageView? {
        
        return findHairlineImageViewUnder(view: navigationBar)
    }
    fileprivate func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        
        if view is UIImageView && view.bounds.height <= 1.0 {
            return view as? UIImageView
        }
        for subView in view.subviews {
            
            let imageView = findHairlineImageViewUnder(view: subView)
            
            if imageView != nil {
                
                return imageView
            }
        }
        return nil
    }

    open func isLineHidden() -> Bool {
        
        return true
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navBarHairlineImageView?.isHidden = isLineHidden()
    }
    open var transitionType: TSNaviTransionType = .push

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let shared = TSConfig_Swift.shared
        
        if !shared.NaviBackground_HEXColor.isEmpty {
            
            navigationBar.barTintColor = TSHEXCOLOR(hexColor: shared.NaviBackground_HEXColor)
        }
        
        if !shared.Title_HEXColor.isEmpty {
            
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: shared.Title_FontSize),
                NSAttributedString.Key.foregroundColor: TSHEXCOLOR(hexColor: shared.Title_HEXColor)
            ]
        }
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            let shared = TSConfig_Swift.shared
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItem(imageName: shared.Back_Image, target: self, action: #selector(pop))
        } else {
            
            if transitionType == .present {
                
                let shared = TSConfig_Swift.shared
                
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItem(imageName: shared.Back_Image, target: self, action: #selector(pop))
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
extension TSNaviController {
    
    @objc func pop() {
        
        if transitionType == .push {
            
            popViewController(animated: true)
        } else {
            
            topViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

