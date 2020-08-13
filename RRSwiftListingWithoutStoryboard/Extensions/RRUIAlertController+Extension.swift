//
//  RRUIAlertController+Extension.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    
    class private func getAlertController(title : String, message : String?) -> UIAlertController {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.black]

        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont as [NSAttributedString.Key : Any])
        let messageAttrString = NSMutableAttributedString(string: message ?? "", attributes: messageFont as [NSAttributedString.Key : Any])

        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        return alertController
    }
    
    class func showAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil){
        let alertController = getAlertController(title: title ?? "", message: message)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            handler?(alertController)
        }))
        //appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    class func showBottomSheet(title : String?, message : String?, handler: ((RRSortEnum) -> Void)? = nil) {
        let alertController = getAlertController(title: title ?? "", message: message)
        alertController.addAction(UIAlertAction.init(title: RRSortEnum.all.title, style: .default, handler: { (action) in
            handler?(.all)
        }))
        alertController.addAction(UIAlertAction.init(title: RRSortEnum.text.title, style: .default, handler: { (action) in
            handler?(.text)
        }))
        alertController.addAction(UIAlertAction.init(title: RRSortEnum.image.title, style: .default, handler: { (action) in
            handler?(.image)
        }))
        alertController.addAction(UIAlertAction.init(title: RRSortEnum.other.title, style: .default, handler: { (action) in
            handler?(.other)
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
