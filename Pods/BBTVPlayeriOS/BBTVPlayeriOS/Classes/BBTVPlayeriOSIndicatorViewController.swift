//
//  BBTVPlayeriOSIndicatorViewController.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 22/4/2563 BE.
//

import UIKit

public protocol BBTVPlayeriOSIndicatorDelegate {
    func indicatorStatus(isLoading: Bool?)
}

public class BBTVPlayeriOSIndicatorViewController: UIViewController {
    public var delegate: BBTVPlayeriOSIndicatorDelegate?
    public var indicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    public override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.startAnimating()
        view.addSubview(indicatorView)
        
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension BBTVPlayeriOSIndicatorViewController: BBTVPlayeriOSIndicatorDelegate {
    public func indicatorStatus(isLoading: Bool?) {
        if let _isLoading = isLoading {
            if _isLoading {
                self.indicatorView.startAnimating()
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            } else {
                self.indicatorView.stopAnimating()
                self.view.backgroundColor = .clear
            }
        }
    }
}
