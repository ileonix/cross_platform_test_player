//
//  BBTVPlayeriOSTitleView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 15/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSTitleView: UIView {
    private weak var container: UIViewController?
    public var titleLabel: UILabel = UILabel()
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?){
        self.container = container
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        
        updatePosition()
        setUpUI()
    }
    
    public func setUpUI(){
    }
    
    func updatePosition(){
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        var guide: AnyObject = superview
        if #available(iOS 11.0, *) {
            guide = superview.safeAreaLayoutGuide
        }
        
        titleLabel.text = nil
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
