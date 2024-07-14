
import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func sd_setImageCustom(url:String,placeHolderImage:UIImage? = nil,complation : ((UIImage?)->())? = nil) {
        
        if let url = URL(string: url) {
            let indicator : SDWebImageActivityIndicator = SDWebImageActivityIndicator.gray
            indicator.indicatorView.color = .gray
            self.sd_imageIndicator = indicator//SDWebImageActivityIndicator.gray
            self.sd_setImage(with: url, placeholderImage: placeHolderImage, options: .transformAnimatedImage) { (image, error, catchImage, url) in
                if let error = error {
                    print("Image URL : ",String(describing: url))
                    print("SDError : ",error)
                    DispatchQueue.main.async {
                        self.image = placeHolderImage
                        complation?(nil)
                    }
                    return
                }
                
                guard let image = image else {
                    DispatchQueue.main.async {
                        self.image = placeHolderImage
                        complation?(nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = image
                    complation?(image)
                }
            }
        }else {
            DispatchQueue.main.async {
                self.image = placeHolderImage
                complation?(nil)
            }
        }
    }
    
}
