//
//  BBTVPlayeriOSCoverImageViewController.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 22/4/2563 BE.
//

import UIKit

public class BBTVPlayeriOSCoverImageViewController: UIViewController, BBTVPlayeriOSIndicatorDelegate {
    public  var coverImage = UIImageView()
    public override func loadView() {
        view = UIView()
        coverImage.contentMode = .scaleAspectFill
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coverImage)
        coverImage.backgroundColor = .systemGray
        coverImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        coverImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        coverImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    public func setImage(image: UIImage?) {
        
        coverImage.image = image
    }
}

extension BBTVPlayeriOSCoverImageViewController {
    public func indicatorStatus(isLoading: Bool?) {
        if let _isLoading = isLoading {
            if _isLoading {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            } else {
                self.view.backgroundColor = .clear
            }
        }
    }
}
