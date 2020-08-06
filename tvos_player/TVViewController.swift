import AVFoundation
import AVKit
import BBTVPlayeriOS
import UIKit
import SwiftUI
import Kingfisher

import BrightcovePlayerSDK

fileprivate struct ConfigConstants {
    static let PolicyKey = "BCpkADawqM1iJLkAypdDVBr7dfEBn6rxotRl3nTTOnnSZ9LWGHZl1k12mAmfmuMZ0G0z04MxYNntjlWl6l-ARbBanPJ6ldtKviZba24I1j-wtCcFBpVarTw8vGePG2RtG7t0no_ezyzeRH-F"
    static let AccountID = "5282994675001"
    static let VideoID = "6013060351001"
    static let adTagURL = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    static let adTagURLTest = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
}

class TVViewController: UIViewController {
    let accountId = ConfigConstants.AccountID
    let policyKey = ConfigConstants.PolicyKey
    let kViewControllerVideoID = ConfigConstants.VideoID
    
    private var item: [String: Any?] = [:] //BBTVPlayerKit
    
    private var playlistSource =
        [ "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
          "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"]
    
    
    private var control : BBTVPlayeriOSCustomControl?
    private var repeatPlayer : BBTVPlayeriOSRepeatViewController?
    private var indicator : BBTVPlayeriOSIndicatorViewController?
    
    private var videoView: UIView!
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    var swiftUIButton: UIButton!
    var configuraBar: UIView!
    var playlistTableView : UITableView!
    var playlistViewCell: PlaylistViewCell!
    var playlistItem: [samples] = []
    var legacyUIKitButton: UIButton!
    var legacyVideo: BBTVPlayeriOS!
//    var legacyUIKitSwitch: UISwitch!
    var isLegacyUIKitSwitchStateOn: Bool = false
    var isAutoPlay: Bool = true//false
    var isAutoRepeat: Bool = true//false
    var isShowControl: Bool = true//false
    var AutoPlayButton: UIButton!
    var AutoRepeatButton: UIButton!
    var showControlButton: UIButton!
    
    @objc func chooseSwiftUIAction(sender: UIButton!) {
        if #available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *) {
            var oSwiftUITestView = PlayerViewSwiftUI()
            oSwiftUITestView.onDismiss = { self.resetVideoUI() }
            let destination = UIHostingController(rootView: oSwiftUITestView)
            self.addChild(destination)
            if let _videoView = self.videoView  {
                self.resetVideoUI()
                _videoView.addSubview(destination.view)
                destination.view.translatesAutoresizingMaskIntoConstraints = false
                destination.view.topAnchor.constraint(equalTo: _videoView.topAnchor).isActive = true
                destination.view.rightAnchor.constraint(equalTo: _videoView.rightAnchor).isActive = true
                destination.view.leftAnchor.constraint(equalTo: _videoView.leftAnchor).isActive = true
                destination.view.bottomAnchor.constraint(equalTo: _videoView.bottomAnchor).isActive = true
            }
        }
    }
    
    @objc func chooseLegacyUIKitAction( items: [Any]) {
        self.control = BBTVPlayeriOSCustomControl()
        self.repeatPlayer = BBTVPlayeriOSRepeatViewController()
        self.indicator = BBTVPlayeriOSIndicatorViewController()
        var Configure: BBTVPlayeriOSConfigure?
        
        if let inner_items = items as? [items] {
            if inner_items.count > 0 {
                if inner_items[0].drm_scheme != nil { //isDRM {
                    print("did DRMlink: \(inner_items[0])")
                    Configure = BBTVPlayeriOSConfigure(srcDrm: inner_items[0].uri)
                        .setCoverImage(UIImage(named:"place_holderLand")?.withRenderingMode(.alwaysOriginal))
                        .setAutoPlay(self.isAutoPlay)
                        .setAutoRepeat(self.isAutoRepeat)
                        .setShowControl(self.isShowControl)
                        .build()
                        .setSrcDrm(inner_items[0].uri!)
                        .setNames([inner_items[0].name!])
                } else {
                    if inner_items.count > 1 {
                        var uris: [String] = []
                        var names: [String] = []
                        for (index,item) in inner_items.enumerated() {
                            uris.append(item.uri!)
                            names.append(item.name! + " (\(index + 1)/\(inner_items.count))")
                        }
                        Configure = BBTVPlayeriOSConfigure()
                            .setCoverImage(UIImage(named:"place_holderLand")?.withRenderingMode(.alwaysOriginal))
                            .setAutoPlay(self.isAutoPlay)
                            .setAutoRepeat(self.isAutoRepeat)
                            .setShowControl(self.isShowControl)
                            .setPlaylist(uris)
                            .setNames(names)
                            .build()
                    } else if inner_items[0].uri!.contains("v2") {
                        if inner_items[0].uri!.contains("-bcid"){
                            // Have BCID
                            Configure = BBTVPlayeriOSConfigure(siteId: "brightcove", entryId: "444177", bcId: "5839043584001", accountId: accountId, policyKey: policyKey)
                                .setCoverImage(UIImage(named:"place_holderLand")?.withRenderingMode(.alwaysOriginal))
                                .setAutoPlay(self.isAutoPlay)
                                .setAutoRepeat(self.isAutoRepeat)
                                .setShowControl(self.isShowControl)
                                .build()
                                .setNames([inner_items[0].name ?? "nil name"])
                        }else {
                            // Non-Have BCID
                            Configure = BBTVPlayeriOSConfigure(siteId: "bugaboo", entryId: "461606", accountId: accountId, policyKey: policyKey)
                                .setCoverImage(UIImage(named:"place_holderLand")?.withRenderingMode(.alwaysOriginal))
                                .setAutoPlay(self.isAutoPlay)
                                .setAutoRepeat(self.isAutoRepeat)
                                .setShowControl(self.isShowControl)
                                .build()
                                .setNames([inner_items[0].name ?? "nil name"])
                        }
                    } else {
                        if inner_items[0].extension == "bc" {
                            Configure = BBTVPlayeriOSConfigure(siteId: "brightcove", entryId: "", bcId: inner_items[0].uri!, accountId: accountId, policyKey: policyKey)
                                .setCoverImage(UIImage(named:"place_holderLand")?.withRenderingMode(.alwaysOriginal))
                                .setAutoPlay(self.isAutoPlay)
                                .setAutoRepeat(self.isAutoRepeat)
                                .setShowControl(self.isShowControl)
                                .build()
                                .setNames([inner_items[0].name ?? "nil name"])
                        } else {
                            print("did !DRMlink: \(String(describing: link))")
                            Configure = BBTVPlayeriOSConfigure()
                                .setCoverImage(UIImage(named:"place_holderLand")?.withRenderingMode(.alwaysOriginal))
                                .setAutoPlay(self.isAutoPlay)
                                .setAutoRepeat(self.isAutoRepeat)
                                .setShowControl(self.isShowControl)
                                .build()
                                .setPlaylist([inner_items[0].uri!])
                                .setNames([inner_items[0].name ?? "nil name"])
                        }
                    }
                }
            }
        }
        
        self.resetVideoUI()
        self.legacyVideo = BBTVPlayeriOS(configure: Configure,
                                         control: self.control,
                                         indicator: self.indicator,
                                         repeatPlayer: self.repeatPlayer)
        if let _legacyVideo = self.legacyVideo {
            if let control = self.control {
                self.addChild(control)
            }
            if let repeatPlayer = self.repeatPlayer {
                self.addChild(repeatPlayer)
            }
            self.control?.videoView = self.legacyVideo
            _legacyVideo.controlDelegate = self
            if let _videoView = self.videoView {
                _videoView.addSubview(_legacyVideo)
                _legacyVideo.translatesAutoresizingMaskIntoConstraints = false
                _legacyVideo.topAnchor.constraint(equalTo: _videoView.topAnchor).isActive = true
                _legacyVideo.rightAnchor.constraint(equalTo: _videoView.rightAnchor).isActive = true
                _legacyVideo.leftAnchor.constraint(equalTo: _videoView.leftAnchor).isActive = true
                _legacyVideo.bottomAnchor.constraint(equalTo: _videoView.bottomAnchor).isActive = true
            }
        }
    }
    
    @objc func showControlAction(_ sender: UIButton) {
        sender.isSelected = !self.isShowControl
        self.isShowControl = sender.isSelected
        if sender.isSelected {
            sender.tintColor = UIColor.white
            self.legacyVideo?.showsCustomControls = true
        } else {
            sender.tintColor = UIColor.gray.withAlphaComponent(0.3)
            self.legacyVideo?.showsCustomControls = false
        }
    }
    
    @objc func AutoPlayAction(_ sender: UIButton) {
        sender.isSelected = !self.isAutoPlay
        self.isAutoPlay = sender.isSelected
        if sender.isSelected {
            sender.tintColor = UIColor.white
            self.legacyVideo?.isAutoPlay = true
        } else {
            sender.tintColor = UIColor.gray.withAlphaComponent(0.3)
            self.legacyVideo?.isAutoPlay = false
        }
    }
    
    @objc func AutoRepeatAction(_ sender: UIButton) {
        sender.isSelected = !self.isAutoRepeat
        self.isAutoRepeat = sender.isSelected
        if sender.isSelected {
            sender.tintColor = UIColor.white
            self.legacyVideo?.shouldAutoRepeat = true
        } else {
            sender.tintColor = UIColor.gray.withAlphaComponent(0.3)
            self.legacyVideo?.shouldAutoRepeat = false
        }
    }
    
    // MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insetsLayoutMarginsFromSafeArea = false
        self.setBackgroundColor()
        self.setUI()
        setupLeftSwipedGestureRecognizer()
        setupRightSwipedGestureRecognizer()
        self.chooseLegacyUIKitAction(items: self.playlistItem[5].items)
    }
    
    //remote
    //    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    //        for press in presses {
    //            if (press.type == .Select) {
    //               // Select is pressed
    //            }  else {
    //                super.pressesEnded(presses, withEvent: event)
    //            }
    //        }
    //    }
    
//    var touchStart: TimeInterval?
//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touches.forEach({ touch in
//            switch touch.type{
//                case .indirect:
//                    self.touchStart = touch.timestamp
//                break
//                default:
//                break
//            }
//
//        })
//    }
//
//    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touches.forEach({ touch in
//            switch touch.type{
//                case .indirect:
//                    if
//                        let start = self.touchStart,
//                        (touch.timestamp - start < 0.5){
//                        super.touchesEnded(touches, with: event)
//                    }else {
//                        //self.performSegue(withIdentifier: SegueEnum.showOverlaySegue.rawValue, sender: nil)
//                    }
//                break
//                default:
//                break
//            }
//        })
//    }
    
    var items_number = 0
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let buttonPress = presses.first?.type else { return }
        switch(buttonPress) {
        case .menu:
            print("Button: Menu")
            exit(0)
        case .playPause:
            if (self.control?.player!.rate)! > 0.0 {
                self.control?.player?.pause()
                print("Button: Pause")
            } else {
                self.control?.player?.play()
                print("Button: Play")
            }
        case .select:
            print("Button: select")
            
        case .upArrow:
            print("Button: Up arrow")
            items_number += 1
            if items_number < 13 {
                self.chooseLegacyUIKitAction(items: self.playlistItem[items_number].items)
            } else {
                items_number = 0
            }
        case .downArrow:
            print("Button: Down arrow")
            items_number -= 1
            if items_number > 0 {
                self.chooseLegacyUIKitAction(items: self.playlistItem[items_number].items)
            } else {
                items_number = 13
            }
        case .leftArrow:
            print("Button: Left arrow")
            self.pressStart = presses.first?.timestamp
            swipedLeft()
        case .rightArrow:
            print("Button: right arrow")
            self.pressStart = presses.first?.timestamp
            swipedRight()
        @unknown default:
            print("Button: unknow")
        }
    }
    
    var pressStart: TimeInterval?
    var pressCount = 1
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let buttonPress = presses.first?.type else {
            return
        }
        switch(buttonPress) {
        case .menu:
            break
        case .upArrow:
            break
        case .downArrow:
            break
        case .leftArrow:
            pressCount = 1
            let minDurationInSecond = CMTimeGetSeconds(CMTime(seconds: 0.0, preferredTimescale: 600))
            if let start = self.pressStart,
                (presses.first!.timestamp - start < 0.5){
                super.pressesEnded(presses, with: event)
            }else {
//                repeat {
//                    self.seek(to: CMTimeGetSeconds((self.control?.player?.currentTime())!) - 1.0)
//                    print("Button: long left \(self.control!.player!.currentTime())/\(minDurationInSecond)")
//                } while (CMTimeGetSeconds((self.control!.player?.currentTime())!) > minDurationInSecond)
            }
        case .rightArrow:
            let maxDurationInSecond = CMTimeGetSeconds(self.control!.player?.currentItem?.duration ?? CMTime(seconds: 0.0, preferredTimescale: 600))
            if let start = self.pressStart,
                (presses.first!.timestamp - start < 0.5){
                super.pressesEnded(presses, with: event)
                print("Button: long right start")
            }else {
//                repeat {
//                    self.seek(to: CMTimeGetSeconds((self.control?.player?.currentTime())!) + 1.0)
//                    print("Button: long right \(CMTimeGetSeconds(self.control!.player!.currentTime()))/\(maxDurationInSecond)")
//                } while (CMTimeGetSeconds((self.control!.player?.currentTime())!) < maxDurationInSecond)
                if (self.control?.player!.rate)! >= 1.0 {
                    pressCount += 1
                    let rate = powf(2.0, Float(pressCount))
                    print("Button: long right \(rate)")
                    self.control?.player?.rate = rate
                }
            }
        case .select:
            break
        case .playPause:
            pressCount = 1
            break
        @unknown default:
            break
        }
    }
    
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let buttonPress = presses.first?.type else {
            return
        }
        switch(buttonPress){
        case .upArrow:
            break
        case .downArrow:
            break
        case .leftArrow:
            break
        case .rightArrow:
            print("Button: change right press")
            self.control?.player?.pause()
            self.control?.player?.rate = 1.0
            self.control?.player?.play()
        case .select:
            break
        case .menu:
            break
        case .playPause:
            break
        @unknown default:
            break
        }
    }
    
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let buttonPress = presses.first?.type else {
            return
        }
        switch(buttonPress){
        case .upArrow:
            break
        case .downArrow:
            break
        case .leftArrow:
            break
        case .rightArrow:
            print("Button: cancel right press")
            self.control?.player?.pause()
            self.control?.player?.rate = 1.0
            self.control?.player?.play()
        case .select:
            break
        case .menu:
            break
        case .playPause:
            break
        @unknown default:
            break
        }
    }
    
    func setupRightSwipedGestureRecognizer() {
       let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
       swipeRecognizer.direction = .right
       view.addGestureRecognizer(swipeRecognizer)
    }
        
    @objc func swipedRight() {
        let duration = CMTimeGetSeconds(self.control!.player?.currentTime() ?? CMTime(seconds: 0.0, preferredTimescale: 600))
        let targetTimeInSecond = duration + 10.0
        let maxDurationInSecond = CMTimeGetSeconds(self.control!.player?.currentItem?.duration ?? CMTime(seconds: 0.0, preferredTimescale: 600))
        
        if targetTimeInSecond > maxDurationInSecond {
            self.seek(to: maxDurationInSecond)
        } else {
            self.seek(to: targetTimeInSecond)
        }
        print("Button: Swiped right \(duration) -> \(targetTimeInSecond)/\(maxDurationInSecond)")
    }
    
    func setupLeftSwipedGestureRecognizer() {
       let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeRecognizer.direction = .left
       view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func swipedLeft() {
//        print("Button: Swiped Left")
        let duration = CMTimeGetSeconds(self.control!.player?.currentTime() ?? CMTime(seconds: 0.0, preferredTimescale: 600))
        let targetTimeInSecond = duration - 10.0
        let minDurationInSecond = CMTimeGetSeconds(CMTime(seconds: 0.0, preferredTimescale: 600))
        if targetTimeInSecond < minDurationInSecond {
            self.seek(to: minDurationInSecond)
        } else {
            self.seek(to: targetTimeInSecond)
        }
        print("Button: Swiped Left \(duration) -> \(minDurationInSecond)/ \(targetTimeInSecond)")
    }
    
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        self.control!.player?.seek(to: cmTime, completionHandler: { (success) in
            if success {
                print("Button: Seek success")
            } else {
                print("Button: Seek fail")
            }
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Will Transition to size \(size) from super view size \(self.view.frame.size)")
        self.setBackgroundColor()
//        if UIDevice.current.orientation.isPortrait {
//            print("isPortrait")
//            self.playlistTableView.isHidden = false
//            self.playlistTableView.delegate = self
//            self.playlistTableView.dataSource = self
//            self.configuraBar.isHidden = false
//            NSLayoutConstraint.deactivate(isLandscapeUIContainerConstraints)
//            NSLayoutConstraint.activate(isPortraitUIContainerConstraints)
//        } else {
            print("isLandscape")
            self.playlistTableView.isHidden = true
            self.playlistTableView.delegate = nil
            self.playlistTableView.dataSource = nil
            
            self.configuraBar.isHidden = true
            NSLayoutConstraint.deactivate(isPortraitUIContainerConstraints)
            NSLayoutConstraint.activate(isLandscapeUIContainerConstraints)
//        }
    }
    
    private func setBackgroundColor() {
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0.3)//(displayP3Red: 25/250, green: 25/250, blue: 25/250, alpha: 1)
    }
    
    private func setUI()  {
        self.setVideoUI()
        self.setLegacyUIKitButton()
        self.setSwiftUIButton()
//        self.setLegacyUIKitSwitch()
        self.setTableView()
        self.setAutoPlayButton()
        self.setAutoRepeatButton()
        self.setShowControlButton()
        self.setConfiguraBar()
        NSLayoutConstraint.activate(isPortraitUIContainerConstraints)
    }
    
    private func setVideoUI()  {
        self.videoView = {
            let initialview: UIView = UIView()
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.backgroundColor = .black
            self.view.addSubview(initialview)
            return initialview
        }()
    }
    
    private func resetVideoUI() {
        if let _videoView = self.videoView  {
            _videoView.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        if let legacyVideo = self.legacyVideo {
            legacyVideo.avq?.pause()
            legacyVideo.avq?.replaceCurrentItem(with: nil)
            legacyVideo.avq = nil
            legacyVideo.removeFromSuperview()
            self.legacyVideo = nil
        }
    }
    
    func setLegacyUIKitButton() {
        self.legacyUIKitButton = {
            let initialview = UIButton(type: .custom)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.backgroundColor = .blue
            initialview.setTitle("Choose  Legacy UIKit", for: .normal)
            initialview.addTarget(self, action: #selector(chooseLegacyUIKitAction), for: .touchUpInside)
            return initialview
        }()
    }
    
    func setSwiftUIButton() {
        self.swiftUIButton = {
            let initialview = UIButton(type: .custom)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.backgroundColor = .blue
            initialview.setTitle("Choose SwiftUI", for: .normal)
            initialview.addTarget(self, action: #selector(chooseSwiftUIAction), for: .touchUpInside)
            return initialview
        }()
    }
    
//    func setLegacyUIKitSwitch() {
//        self.legacyUIKitSwitch = {
//            let initialview = UISwitch(frame: .zero)
//            initialview.translatesAutoresizingMaskIntoConstraints = false
//            initialview.setOn(self.isLegacyUIKitSwitchStateOn, animated: true)
//
//            let title = UILabel(frame: .zero)
//            title.frame = CGRect(x: initialview.frame.midX + initialview.frame.width, y: initialview.frame.midY, width: 200.0, height: 22.0)
//            title.text = "Enable Play DRM Content"
//            initialview.addSubview(title)
//
//            return initialview
//        }()
//    }
    
    func setTableView() {
        self.playlistTableView = {
            let initialview = UITableView()
            initialview.register(PlaylistViewCell.self, forCellReuseIdentifier: PlaylistViewCell.identifier)
            initialview.dataSource = self
            initialview.delegate = self
            initialview.estimatedRowHeight = 150
            initialview.rowHeight = UITableView.automaticDimension
            
            initialview.setDefaultCH7HD(bHaveFooter: true)//.setDefaultCH7HD(sSeparatorStyle: .none, bHaveFooter: true)
            initialview.backgroundColor = UIColor(displayP3Red: 25/250, green: 25/250, blue: 25/250, alpha: 1)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            
            if let sample = ReadJSON.samples {
                for (_,item) in sample.enumerated() {
                    self.playlistItem.append(item)
                }
            }
            self.view.addSubview(initialview)
            return initialview
        }()
    }
    
    func setConfiguraBar() {
        self.configuraBar = {
            let initialview = UIView()
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.backgroundColor = UIColor(displayP3Red: 25/250, green: 25/250, blue: 25/250, alpha: 1)
            
            if let  _AutoPlayButton = self.AutoPlayButton,
                let  _AutoRepeatButton = self.AutoRepeatButton,
                let _ShowControlButton = self.showControlButton {
                initialview.addSubview(_AutoPlayButton)
                _AutoPlayButton.trailingAnchor.constraint(equalTo: initialview.trailingAnchor, constant: -16.0).isActive = true
                _AutoPlayButton.centerYAnchor.constraint(equalTo: initialview.centerYAnchor).isActive = true
                _AutoPlayButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                _AutoPlayButton.widthAnchor.constraint(equalTo: _AutoPlayButton.heightAnchor).isActive = true
                
                initialview.addSubview(_AutoRepeatButton)
                _AutoRepeatButton.trailingAnchor.constraint(equalTo: _AutoPlayButton.leadingAnchor, constant: -10.0).isActive = true
                _AutoRepeatButton.centerYAnchor.constraint(equalTo: initialview.centerYAnchor).isActive = true
                _AutoRepeatButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                _AutoRepeatButton.widthAnchor.constraint(equalTo: _AutoRepeatButton.heightAnchor).isActive = true
                
                initialview.addSubview(_ShowControlButton)
                _ShowControlButton.trailingAnchor.constraint(equalTo: _AutoRepeatButton.leadingAnchor, constant: -10.0).isActive = true
                _ShowControlButton.centerYAnchor.constraint(equalTo: initialview.centerYAnchor).isActive = true
                _ShowControlButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                _ShowControlButton.widthAnchor.constraint(equalTo: _ShowControlButton.heightAnchor).isActive = true
            }
            
            let underLineView : UIView = UIView()
            underLineView.backgroundColor = UIColor(red: 102/250, green: 102/250, blue: 102/250, alpha: 0.6)
            underLineView.translatesAutoresizingMaskIntoConstraints = false
            initialview.addSubview(underLineView)
            underLineView.bottomAnchor.constraint(equalTo: initialview.bottomAnchor).isActive = true
            underLineView.leadingAnchor.constraint(equalTo: initialview.leadingAnchor, constant: 8.0).isActive = true
            underLineView.trailingAnchor.constraint(equalTo: initialview.trailingAnchor, constant: -8.0).isActive = true
            underLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            
            self.view.addSubview(initialview)
            return initialview
        }()
    }
    
    func setAutoPlayButton() {
        self.AutoPlayButton = {
            let initialview = UIButton(type: .custom)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.tintColor = UIColor.gray.withAlphaComponent(0.3)
            initialview.setImage(UIImage(named: "start"), for: .normal)
            initialview.setImage(UIImage(named: "start"), for: .selected)
            initialview.addTarget(self, action: #selector(AutoPlayAction(_:)), for: .touchUpInside)
            initialview.isSelected = self.isAutoPlay
            return initialview
        }()
    }
    
    func setAutoRepeatButton() {
        self.AutoRepeatButton = {
            let initialview = UIButton(type: .custom)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.tintColor = UIColor.gray.withAlphaComponent(0.3)
            initialview.setImage(UIImage(named: "replay"), for: .normal)
            initialview.setImage(UIImage(named: "replay"), for: .selected)
            initialview.addTarget(self, action: #selector(AutoRepeatAction(_:)), for: .touchUpInside)
            initialview.isSelected = self.isAutoRepeat
            return initialview
        }()
    }
    
    func setShowControlButton() {
        self.showControlButton = {
            let initialview = UIButton(type: .custom)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            initialview.tintColor = UIColor.gray.withAlphaComponent(0.3)
            initialview.setImage(UIImage(named: "control"), for: .normal)
            initialview.setImage(UIImage(named: "control"), for: .selected)
            initialview.addTarget(self, action: #selector(showControlAction(_:)), for: .touchUpInside)
            initialview.isSelected = self.isShowControl
            return initialview
        }()
    }
    
    private lazy var isLandscapeUIContainerConstraints: [NSLayoutConstraint] = {
        
        var axConstraints : [NSLayoutConstraint] = []
        
        var guide: AnyObject = self.view
        var bottomPadding: CGFloat = 0.0
        if let window = UIApplication.shared.keyWindow {
            if #available(iOS 11.0, *) {
                guide = guide.safeAreaLayoutGuide
                
                if window.safeAreaInsets.bottom > 0 {
                    bottomPadding = 22.0
                }
            }
            
            if let _videoView = self.videoView {
                print("isLand1")
                axConstraints += [
                    _videoView.topAnchor.constraint(equalTo: guide.topAnchor),
                    _videoView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                    _videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    _videoView.widthAnchor.constraint(equalTo: _videoView.heightAnchor, multiplier: 16.0/9.0)
                ]
            }
        }
        
        return axConstraints
    }()
    
    private lazy var isPortraitUIContainerConstraints: [NSLayoutConstraint] = {
        var axConstraints : [NSLayoutConstraint] = []
        
        var guide: AnyObject = self.view
        if #available(iOS 11.0, *) {
            guide = guide.safeAreaLayoutGuide
        }
        
        if let _videoView = self.videoView {
            print("isLand2")
            axConstraints += [
//                _videoView.topAnchor.constraint(equalTo: guide.topAnchor),
//                _videoView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
//                _videoView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
//                _videoView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
                _videoView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                _videoView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
//                _videoView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 16) * 9)
            ]
        }
        
        if let _configuraBar = self.configuraBar, let _videoView = self.videoView {
            axConstraints += [
//                _configuraBar.topAnchor.constraint(equalTo: _videoView.bottomAnchor),
//                _configuraBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
//                _configuraBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                _configuraBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                _configuraBar.heightAnchor.constraint(equalToConstant: 44.0)
            ]
        }
        
        if let _tableView = self.playlistTableView, let _videoView = self.videoView , let _configuraBar = self.configuraBar {
            axConstraints += [
                _tableView.topAnchor.constraint(equalTo: _configuraBar.bottomAnchor),
                _tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                _tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                _tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
        }
        return axConstraints
    }()
}

extension TVViewController: BBTVPlayeriOSDelegate {
    func playbackSession(_ session: AVPlayer?, didProgressTo progress: TimeInterval) {
    }
}

extension TVViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReadJSON.samples!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.playlistTableView.dequeueReusableCell(withIdentifier: PlaylistViewCell.identifier, for: indexPath) as! PlaylistViewCell
        if self.playlistItem[indexPath.row].items.count > 0 && self.playlistItem[indexPath.row].items.count <= 1 {
            cell.playlistItemView.setText(text: (self.playlistItem[indexPath.row].items[0].drm_scheme == nil ? "":"[DRM] ") + (self.playlistItem[indexPath.row].items[0].name ?? "-"))
        } else {
            cell.playlistItemView.setText(text: "Playlist")
        }
        if let sUrl = self.playlistItem[indexPath.row].items[0].coverUrl {
            let url = URL(string: sUrl)
            cell.playlistItemView.coverImage.kf.setImage(with: url)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseLegacyUIKitAction(items: self.playlistItem[indexPath.row].items)
    }
}

