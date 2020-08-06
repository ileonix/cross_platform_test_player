//
//  BBTVPlayeriOSRepeatViewController.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 19/6/2563 BE.
//

import UIKit

public protocol BBTVPlayeriOSRepeatDelegate {
    func touchRepeat()
}

public class BBTVPlayeriOSRepeatViewController: UIViewController {
    public var delegate: BBTVPlayeriOSRepeatDelegate?
    {
        didSet {
            RepeatView.delegate = delegate
        }
    }
    public var RepeatView: BBTVPlayeriOSRepeatView! =  BBTVPlayeriOSRepeatView()
    
    public override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        if let _RepeatView = self.RepeatView {
             view.addSubview(_RepeatView)
            _RepeatView.tintColor = .white
            _RepeatView.setup(in: self)
            _RepeatView.translatesAutoresizingMaskIntoConstraints = false
            _RepeatView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            _RepeatView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            _RepeatView.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
            _RepeatView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        }
    }
}
