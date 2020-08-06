//
//  TableExt.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 10/4/2562 BE.
//  Copyright © 2562 BBTV New Media Co., Lted. All rights reserved.
//

import UIKit

extension UITableView {
    struct insets {
        public static var top: CGFloat = 0.0
        public static var bottom: CGFloat = 0.0
        public static var left: CGFloat = 8.0
        public static var right: CGFloat = 8.0
    }
    
    struct background {
        static var color = UIColor.white
    }
    
    func setDefaultCH7HD(/*sSeparatorStyle: UITableViewCell.SeparatorStyle = .singleLine,*/ bHaveFooter: Bool = false, separatorInset: UIEdgeInsets = UIEdgeInsets.init(top: UITableView.insets.top, left: UITableView.insets.left, bottom: UITableView.insets.bottom, right: UITableView.insets.right)) {
        self.allowsSelection = true
        self.preservesSuperviewLayoutMargins = false
        self.cellLayoutMarginsFollowReadableWidth = false
        self.separatorInset = separatorInset // ทำเส้นคั่นให้ full width รบกวนใส cell.layoutMargins = UIEdgeInsetsZero ที่ cell ด้วย
        self.layoutMargins = .zero // ทำเส้นคั่นให้ full width รบกวนใส cell.preservesSuperviewLayoutMargins = false ที่ cell ด้วย
//        self.separatorStyle = sSeparatorStyle //เปิดไว้ก่อน เวลาทำจริงให้ปิดท้ิง
        if !bHaveFooter {
            let view = UIView()
            view.backgroundColor = .clear
            self.tableFooterView = view //ตัดเส้นคั่นที่เป็น default footer ออก
        }
        self.backgroundColor = UITableView.background.color
//        self.separatorColor = UIColor.white.withAlphaComponent(0.12)//UIColor._separatorColor
    }
    
}


extension UITableView {
    func scrollToBottom(animated: Bool = true){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            //print("3", indexPath)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
