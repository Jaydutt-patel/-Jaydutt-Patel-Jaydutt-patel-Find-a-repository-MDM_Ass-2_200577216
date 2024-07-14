//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.



import UIKit



extension UIViewController {
    
    enum Storyboard: String {
        case main = "Main"
    }
    
    
    class func instantiateViewController<T: UIViewController>(identifier : Storyboard) -> T {
        let storyboard =  UIStoryboard(name: identifier.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.self) ")
        }
        
        return viewController
    }
    
    
    func popToViewController(viewController:UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        //view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popToViewController(viewController, animated: false)
    }
    
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setupDefaultNavigation() {
        let appearance = UINavigationBarAppearance()
          appearance.configureWithDefaultBackground()
          appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
          appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
          
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}



extension UIViewController {
    
    func setLeftAlignedNavigationItemTitle(text: String,
                                           color: UIColor,
                                           margin left: CGFloat,font:UIFont = UIFont.systemFont(ofSize: 15))
    {
        let titleLabel = UILabel()
        titleLabel.textColor = color
        titleLabel.text = text
        titleLabel.textAlignment = .left
        titleLabel.font = font
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.titleView = titleLabel
        
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        
        // NOTE: This always seems to be 0. Huh??
        let leftBarItemWidth = self.navigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                             constant: (leftBarItemWidth ?? 0) + left),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
    }
    
}


extension UIViewController {

    // We cannot override load like we could in Objective-C, so override initialize instead
    static func methodSwizlling() {

        // Make a static struct for our dispatch token so only one exists in memory

        // Wrap this in a dispatch_once block so it is only run once
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.myViewDidLoad)

        let originalMethod1 = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod1 = class_getInstanceMethod(self, swizzledSelector)
        guard let swizzledMethod = swizzledMethod1,let originalMethod = originalMethod1 else {return }
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        // class_addMethod can fail if used incorrectly or with invalid pointers, so check to make sure we were able to add the method to the lookup table successfully
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }

    // Our new viewDidLoad function
    // In this example, we are just logging the name of the function, but this can be used to run any custom code
    @objc func myViewDidLoad() {
        // This is not recursive since we swapped the Selectors in initialize().
        // We cannot call super in an extension.
        
        print("====>>> View controller ",self.classForCoder) // logs myViewDidLoad()
    }



}

extension UIViewController {
    func showAlertWithOkAndCancelHandler(string: String,strOk:String,strCancel : String,handler: @escaping (_ isOkBtnPressed : Bool)->Void)
    {
        
        
        let alert = UIAlertController(title: "", message: string, preferredStyle: .alert)
        
        let alertOkayAction = UIAlertAction(title: strOk, style: .default) { (alert) in
            handler(true)
        }
        let alertCancelAction = UIAlertAction(title: strCancel, style: .default) { (alert) in
            handler(false)
        }
        alert.addAction(alertCancelAction)
        alert.addAction(alertOkayAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showAlertwithOkHandler(string:String,strBtnTitle:String,handler: @escaping ()->Void) -> Void {
        
        let alert : UIAlertController = UIAlertController(title: "", message: string, preferredStyle: .alert)
        let alertCancelAction = UIAlertAction(title: strBtnTitle, style: .default) { (alert) in
            handler()
        }
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    func showAlert(string:String) -> Void {
        
        let alert : UIAlertController = UIAlertController(title: "", message: string, preferredStyle: .alert)
        let alertCancelAction = UIAlertAction(title: "Okay", style: .default) { (alert) in
            
        }
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true, completion: nil)

    }
    
}
