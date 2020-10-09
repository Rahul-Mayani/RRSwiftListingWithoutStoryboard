//
//  UIImageViewExtensions.swift
//  MVVM
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Kingfisher

public struct NetworkImage {
    
    public private(set) var url: URL? = nil
    public private(set) var placeholder: UIImage? = nil
    
    public init(withURL url: URL? = nil, placeholder: UIImage? = nil) {
        self.url = url
        self.placeholder = placeholder
    }
}

public extension Reactive where Base: UIImageView {
    
    /// Simple binder for `NetworkImage`
    var networkImage: Binder<NetworkImage> {
        return networkImage()
    }
    
    /// Optional image transition and completion that allow View to do more action after completing download image
    func networkImage(_ imageTransition: UIView.AnimationOptions = [.transitionCrossDissolve, .curveEaseOut]) -> Binder<NetworkImage> {
        return Binder(base) { view, image in
            if let placeholder = image.placeholder {
                view.image = placeholder
            }
            
            if let url = image.url {
                view.kf.setImage(with: url, placeholder: image.placeholder, options: [.transition(.fade(1)), .cacheOriginalImage], completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                        if value.cacheType == .none {
                            UIView.transition(with: view,
                                              duration: 0.35,
                                              options: imageTransition,
                                              animations: {
                                                view.image = value.image
                                              }, completion: nil)
                        } else {
                            view.image = value.image
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                })
               
                /*
                view.af_setImage(withURL: url, imageTransition: imageTransition, completion: { response in
                    /// callback for ViewModel to handle after completion
                    image.completion?(response)
                    
                    /// callback for View to handle after completion
                    completion?(response)
                })
                 */
            }
        }
    }
}








