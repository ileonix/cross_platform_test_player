//
//  UIImageView+URL.swift
//  BBTVPlayerKit
//
//  Created by N. Kimchan on 12/2/16.
//  Copyright © 2016 BBTV New Media Co., Ltd. All rights reserved.
//

import UIKit

extension UIImageView {
    func image(url:URL)  {
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            
        }).resume()
    }
    func image(string: String)  {
        let url: URL = URL(string: string)!
        self.image(url: url)
    }
 
}
