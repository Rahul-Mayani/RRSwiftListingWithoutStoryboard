//
//  RRLoader.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import UIKit

private let vLoader = UIView()

private let activityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(0,0,50,50), type: .ballRotateChase, color: UIColor.blueColor(), padding: CGFloat(0))
//private let activityIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)

struct RRLoader {
    
    static func startLoaderToAnimating(_ isMask: Bool = true)  {
        
        DispatchQueue.main.async {
            if isMask {
                vLoader.frame = UIScreen.main.bounds
                vLoader.backgroundColor = UIColor.blackColor().withAlphaComponent(0.2)
                appDelegate.window?.addSubview(vLoader)
            }
            
            //activityIndicatorView.color = R.color.themeColor()
            //activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.center = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
            appDelegate.window?.addSubview(activityIndicatorView)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activityIndicatorView.startAnimating()
        }
    }
    
    static func stopLoaderToAnimating() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            activityIndicatorView.stopAnimating()
            vLoader.removeFromSuperview()
        }
    }
}
