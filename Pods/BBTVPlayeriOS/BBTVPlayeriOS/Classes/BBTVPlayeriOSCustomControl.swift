//
//  BBTVPlayeriOSCustomControl.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 22/4/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSCustomControl: BBTVPlayeriOSControl {
    private var guideLineRewindButton: UIView = UIView()
    private var guideLinefastForwardButton: UIView = UIView()
    public var playPauseButton: BBTVPlayeriOSPlayPauseView?
    public var rewindButton: BBTVPlayeriOSRewindView?
    public var fastForwardButton: BBTVPlayeriOSFastForwardView?
    public var playlistButton: BBTVPlayeriOSPlaylistView?
    public var playlistTable: BBTVPlayeriOSPlaylistTableView?
    public var speedRateButton: BBTVPlayeriOSSpeedRateView?
//    public var slider: BBTVPlayeriOSSliderView?
    public var closeButton: BBTVPlayeriOSCloseVideoView?
    public var fullScreenButton: BBTVPlayeriOSFullScreenView?
    public var titleButton: BBTVPlayeriOSTitleView?
    public var durationStyleButton: BBTVPlayeriOSDurationStyleView?
    public var liveStyleButton: BBTVPlayeriOSLiveStyleView?
    public var previousButton: BBTVPlayeriOSPreviousView?
    public var nextButton: BBTVPlayeriOSNextView?
    public var videoView: BBTVPlayeriOS?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.durationStyleButton = BBTVPlayeriOSDurationStyleView()
        if let _durationButton = self.durationStyleButton {
            self.fadeHideView.addSubview(_durationButton)
            _durationButton.setup(in: self, configure: Configure)
            _durationButton.tintColor = .white
            _durationButton.durationLabel.setTitle("..:../..:..", for: .normal)
        }
        
        self.liveStyleButton = BBTVPlayeriOSLiveStyleView()
        if let _liveStyleButton = self.liveStyleButton {
            self.noFadeHideView.addSubview(_liveStyleButton)
            _liveStyleButton.setup(in: self, configure: Configure)
            _liveStyleButton.tintColor = .white
        }
        
        self.playPauseButton = BBTVPlayeriOSPlayPauseView()
        if let _playPauseButton = self.playPauseButton {
            self.fadeHideView.addSubview(_playPauseButton)
            _playPauseButton.setup(in: self, configure: Configure)
            _playPauseButton.tintColor = .white
        }
        
//        self.slider = BBTVPlayeriOSSliderView()
//        if let _slider = self.slider {
//            self.fadeHideView.addSubview(_slider)
//            _slider.setup(in: self, configure: Configure, color: .white)
//            if let _playPauseButton = self.playPauseButton {
//                _slider.delegatePlayPause = _playPauseButton
//            }
//
//            if let _durationStyleButton = self.durationStyleButton {
//                _slider.delegateDuration = _durationStyleButton
//            }
//        }
        
        self.rewindButton = BBTVPlayeriOSRewindView()
        if let _rewindButton = self.rewindButton {
            self.fadeHideView.addSubview(_rewindButton)
            _rewindButton.setup(in: self, configure: Configure)
            _rewindButton.tintColor = .white
//            if let _slider = self.slider {
//                _rewindButton.delegateSlider = _slider
//            }
        }
        
        self.fastForwardButton = BBTVPlayeriOSFastForwardView()
        if let _fastForwardButton = self.fastForwardButton {
            self.fadeHideView.addSubview(_fastForwardButton)
            _fastForwardButton.setup(in: self, configure: Configure)
            _fastForwardButton.tintColor = .white
//            if let _slider = self.slider {
//                _fastForwardButton.delegateSlider = _slider
//            }
        }
        
        self.closeButton = BBTVPlayeriOSCloseVideoView()
        if let _closeButton = self.closeButton {
            self.fadeHideView.addSubview(_closeButton)
            _closeButton.setup(in: self, configure: Configure)
            _closeButton.tintColor = .white
        }
        
        self.fullScreenButton = BBTVPlayeriOSFullScreenView()
        if let _fullScreenButton = self.fullScreenButton {
            self.fadeHideView.addSubview(_fullScreenButton)
            _fullScreenButton.setup(in: self, configure: Configure)
            _fullScreenButton.tintColor = .white
            _fullScreenButton.delegate = self
        }
        
        self.titleButton = BBTVPlayeriOSTitleView()
        if let _titleButton = self.titleButton {
            self.fadeHideView.addSubview(_titleButton)
            _titleButton.setup(in: self, configure: Configure)
            _titleButton.tintColor = .white
            
            if self.Configure?.playlist.count ?? 0 > 0 {
                if self.Configure?.playlist.count ?? 0 <= 1 {
                    _titleButton.titleLabel.text = self.Configure?.names[0]
                } else {
                    if let playerItems = self.videoView?.avPlayerItems {
                        for (index,playingItem) in playerItems.enumerated() {
                            if self.videoView?.avq?.currentItem == playingItem {
                                _titleButton.titleLabel.text = self.Configure?.names[index]
                            }
                        }
                    } else {
                        _titleButton.titleLabel.text = ""
                    }
                }
            } else {
                _titleButton.titleLabel.text = self.Configure?.names[0]
            }
        }
        
        if self.isPlayList {
            self.nextButton = BBTVPlayeriOSNextView()
            if let _nextButton = self.nextButton {
                self.fadeHideView.addSubview(_nextButton)
                _nextButton.setup(in: self, configure: Configure)
                _nextButton.tintColor = .white
            }
            
            self.playlistTable = BBTVPlayeriOSPlaylistTableView()
            if let _playlistTable = self.playlistTable {
                self.fadeHideView.addSubview(_playlistTable)
                _playlistTable.setup(in: self, configure: Configure)
                _playlistTable.delegate = self
            }
            
            self.playlistButton = BBTVPlayeriOSPlaylistView()
            if let _playlistButton = self.playlistButton {
                self.fadeHideView.addSubview(_playlistButton)
                _playlistButton.setup(in: self, configure: Configure)
                _playlistButton.tintColor = .white
                _playlistButton.delegate = self
            }
        }
        
        guideLineRewindButton.translatesAutoresizingMaskIntoConstraints = false
        guideLinefastForwardButton.translatesAutoresizingMaskIntoConstraints = false
        self.fadeHideView.addSubview(guideLineRewindButton)
        self.fadeHideView.addSubview(guideLinefastForwardButton)
        
        NSLayoutConstraint.activate(isPortraitUIContainerConstraints)
    }
    
    private lazy var isLandscapeUIContainerConstraints: [NSLayoutConstraint] = {
        var axConstraints : [NSLayoutConstraint] = []
        
        var guide: AnyObject = self.view
        if #available(iOS 11.0, *) {
            guide = guide.safeAreaLayoutGuide
        }
        
        if let _playPauseButton = self.playPauseButton {
            axConstraints += [
                _playPauseButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                _playPauseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                _playPauseButton.widthAnchor.constraint(equalToConstant: 44.0),
                _playPauseButton.heightAnchor.constraint(equalToConstant: 44.0)
            ]
        }
        
        if let _playPauseButton = self.playPauseButton, let _rewindButton = self.rewindButton {
            axConstraints += [
                guideLineRewindButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                guideLineRewindButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                guideLineRewindButton.trailingAnchor.constraint(equalTo: _playPauseButton.leadingAnchor),
                _rewindButton.widthAnchor.constraint(equalToConstant: 44.0),
                _rewindButton.heightAnchor.constraint(equalToConstant: 44.0),
                _rewindButton.centerYAnchor.constraint(equalTo: guideLineRewindButton.centerYAnchor),
                _rewindButton.centerXAnchor.constraint(equalTo: guideLineRewindButton.centerXAnchor)
            ]
        }
        
        if let _playPauseButton = self.playPauseButton, let _fastForwardButton = self.fastForwardButton {
            axConstraints += [
                guideLinefastForwardButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                guideLinefastForwardButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                guideLinefastForwardButton.leadingAnchor.constraint(equalTo: _playPauseButton.trailingAnchor),
                _fastForwardButton.widthAnchor.constraint(equalToConstant: 44.0),
                _fastForwardButton.heightAnchor.constraint(equalToConstant: 44.0),
                _fastForwardButton.centerYAnchor.constraint(equalTo: guideLinefastForwardButton.centerYAnchor),
                _fastForwardButton.centerXAnchor.constraint(equalTo: guideLinefastForwardButton.centerXAnchor)
            ]
        }
        
        if self.isPlayList {
//            if let _slider = self.slider,
//                let _nextButton = self.nextButton,
//                let _fullScreenButton = self.fullScreenButton,
//                let _durationButton = self.durationStyleButton,
//                let _liveStyleButton = self.liveStyleButton {
//                let window = UIApplication.shared.keyWindow
//                var bottomPadding: CGFloat! = 0.0
//                if #available(iOS 11.0, *) {
//                    if let fbottom = window?.safeAreaInsets.left {
//                        bottomPadding = fbottom
//                        if bottomPadding <= 0 {
//                            bottomPadding = 16.0
//                        }
//                    }
//                }
//
//                axConstraints += [
//                    _slider.heightAnchor.constraint(equalToConstant: 30.0),
//                    _slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16.0),
//                    _slider.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -(bottomPadding)),
//
//                    _liveStyleButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _liveStyleButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _liveStyleButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _durationButton.bottomAnchor.constraint(equalTo: _slider.topAnchor),
//                    _durationButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _durationButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _nextButton.leadingAnchor.constraint(equalTo: _slider.trailingAnchor, constant: 16.0),
//                    _nextButton.widthAnchor.constraint(equalToConstant: 44.0),
//                    _nextButton.heightAnchor.constraint(equalToConstant: 44.0),
//                    _nextButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//
//                    _fullScreenButton.leadingAnchor.constraint(equalTo: _nextButton.trailingAnchor, constant: 8.0),
//                    _fullScreenButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _fullScreenButton.widthAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.heightAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
//                ]
//            }
            
            if let _closeButton = self.closeButton,
                let _playlistButton = self.playlistButton,
                let _titleButton = self.titleButton {
                axConstraints += [
                    _closeButton.widthAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.heightAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8.0),
                    _closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8.0),
                    
                    _titleButton.leadingAnchor.constraint(equalTo: _closeButton.trailingAnchor, constant: 8.0),
                    _titleButton.centerYAnchor.constraint(equalTo: _closeButton.centerYAnchor),
                    
                    _playlistButton.leadingAnchor.constraint(equalTo: _titleButton.trailingAnchor, constant: 8.0),
                    _playlistButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
                    _playlistButton.centerYAnchor.constraint(equalTo: _closeButton.centerYAnchor),
                    _playlistButton.widthAnchor.constraint(equalToConstant: 44.0),
                    _playlistButton.heightAnchor.constraint(equalToConstant: 44.0)
                ]
            }
        } else {
//            if let _slider = self.slider,
//                let _fullScreenButton = self.fullScreenButton,
//                let _durationButton = self.durationStyleButton,
//                let _liveStyleButton = self.liveStyleButton {
//                let window = UIApplication.shared.keyWindow
//                var bottomPadding: CGFloat! = 0.0
//                if #available(iOS 11.0, *) {
//                    if let fbottom = window?.safeAreaInsets.left {
//                        bottomPadding = fbottom
//                        if bottomPadding <= 0 {
//                            bottomPadding = 16.0
//                        }
//                    }
//                }
//
//                axConstraints += [
//                    _slider.heightAnchor.constraint(equalToConstant: 30.0),
//                    _slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16.0),
//                    _slider.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -(bottomPadding)),
//
//                    _liveStyleButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _liveStyleButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _liveStyleButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _durationButton.bottomAnchor.constraint(equalTo: _slider.topAnchor),
//                    _durationButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _durationButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _fullScreenButton.leadingAnchor.constraint(equalTo: _slider.trailingAnchor, constant: 8.0),
//                    _fullScreenButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _fullScreenButton.widthAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.heightAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
//                ]
//            }
            
            if let _closeButton = self.closeButton,
                let _titleButton = self.titleButton {
                axConstraints += [
                    _closeButton.widthAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.heightAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8.0),
                    _closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8.0),
                    
                    _titleButton.leadingAnchor.constraint(equalTo: _closeButton.trailingAnchor, constant: 8.0),
                    _titleButton.centerYAnchor.constraint(equalTo: _closeButton.centerYAnchor),
                    _titleButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
                ]
            }
        }
        
        return axConstraints
    }()
    
    private lazy var playlistUIContainerConstraints: [NSLayoutConstraint] = {
        var axConstraints : [NSLayoutConstraint] = []
        
        var guide: AnyObject = self.view
        if #available(iOS 11.0, *) {
            guide = guide.safeAreaLayoutGuide
        }
        if let _playlistTable = self.playlistTable {
            axConstraints += [
                _playlistTable.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                _playlistTable.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                _playlistTable.topAnchor.constraint(equalTo: self.view.topAnchor),
                _playlistTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
        }
        return axConstraints
    }()
    
    private lazy var isPortraitUIContainerConstraints: [NSLayoutConstraint] = {
        var axConstraints : [NSLayoutConstraint] = []
        
        var guide: AnyObject = self.view
        if #available(iOS 11.0, *) {
            guide = guide.safeAreaLayoutGuide
        }
        
        if let _playPauseButton = self.playPauseButton {
            axConstraints += [
                _playPauseButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                _playPauseButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                _playPauseButton.widthAnchor.constraint(equalToConstant: 44.0),
                _playPauseButton.heightAnchor.constraint(equalToConstant: 44.0)
            ]
        }
        
        if let _playPauseButton = self.playPauseButton, let _rewindButton = self.rewindButton {
            axConstraints += [
                guideLineRewindButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                guideLineRewindButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                guideLineRewindButton.trailingAnchor.constraint(equalTo: _playPauseButton.leadingAnchor),
                _rewindButton.widthAnchor.constraint(equalToConstant: 44.0),
                _rewindButton.heightAnchor.constraint(equalToConstant: 44.0),
                _rewindButton.centerYAnchor.constraint(equalTo: guideLineRewindButton.centerYAnchor),
                _rewindButton.centerXAnchor.constraint(equalTo: guideLineRewindButton.centerXAnchor)
            ]
        }
        
        if let _playPauseButton = self.playPauseButton, let _fastForwardButton = self.fastForwardButton {
            axConstraints += [
                guideLinefastForwardButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                guideLinefastForwardButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                guideLinefastForwardButton.leadingAnchor.constraint(equalTo: _playPauseButton.trailingAnchor),
                _fastForwardButton.widthAnchor.constraint(equalToConstant: 44.0),
                _fastForwardButton.heightAnchor.constraint(equalToConstant: 44.0),
                _fastForwardButton.centerYAnchor.constraint(equalTo: guideLinefastForwardButton.centerYAnchor),
                _fastForwardButton.centerXAnchor.constraint(equalTo: guideLinefastForwardButton.centerXAnchor)
            ]
        }
        
        if self.isPlayList {
//            if let _slider = self.slider,
//                let _nextButton = self.nextButton,
//                let _fullScreenButton = self.fullScreenButton,
//                let _durationButton = self.durationStyleButton,
//                let _liveStyleButton = self.liveStyleButton {
//                axConstraints += [
//                    _slider.heightAnchor.constraint(equalToConstant: 30.0),
//                    _slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16.0),
//                    _slider.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -8.0),
//
//                    _liveStyleButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _liveStyleButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _liveStyleButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _durationButton.bottomAnchor.constraint(equalTo: _slider.topAnchor),
//                    _durationButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _durationButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _nextButton.leadingAnchor.constraint(equalTo: _slider.trailingAnchor, constant: 16.0),
//                    _nextButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _nextButton.widthAnchor.constraint(equalToConstant: 44.0),
//                    _nextButton.heightAnchor.constraint(equalToConstant: 44.0),
//
//                    _fullScreenButton.leadingAnchor.constraint(equalTo: _nextButton.trailingAnchor, constant: 8.0),
//                    _fullScreenButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _fullScreenButton.widthAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.heightAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
//                ]
//            }
            
            if let _closeButton = self.closeButton,
                let _playlistButton = self.playlistButton,
                let _titleButton = self.titleButton {
                axConstraints += [
                    _closeButton.widthAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.heightAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8.0),
                    _closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8.0),
                    
                    _titleButton.leadingAnchor.constraint(equalTo: _closeButton.trailingAnchor, constant: 8.0),
                    _titleButton.centerYAnchor.constraint(equalTo: _closeButton.centerYAnchor),
                    
                    _playlistButton.leadingAnchor.constraint(equalTo: _titleButton.trailingAnchor, constant: 8.0),
                    _playlistButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
                    _playlistButton.centerYAnchor.constraint(equalTo: _closeButton.centerYAnchor),
                    _playlistButton.widthAnchor.constraint(equalToConstant: 44.0),
                    _playlistButton.heightAnchor.constraint(equalToConstant: 44.0)
                ]
            }
        } else {
//            if let _slider = self.slider,
//                let _fullScreenButton = self.fullScreenButton,
//                let _durationButton = self.durationStyleButton,
//                let _liveStyleButton = self.liveStyleButton {
//                axConstraints += [
//                    _slider.heightAnchor.constraint(equalToConstant: 30.0),
//                    _slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16.0),
//                    _slider.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -8.0),
//
//                    _liveStyleButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _liveStyleButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _liveStyleButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _durationButton.bottomAnchor.constraint(equalTo: _slider.topAnchor),
//                    _durationButton.leadingAnchor.constraint(equalTo: _slider.leadingAnchor),
//                    _durationButton.heightAnchor.constraint(equalToConstant: 24.0),
//
//                    _fullScreenButton.leadingAnchor.constraint(equalTo: _slider.trailingAnchor, constant: 8.0),
//                    _fullScreenButton.centerYAnchor.constraint(equalTo: _slider.centerYAnchor),
//                    _fullScreenButton.widthAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.heightAnchor.constraint(equalToConstant: 32.0),
//                    _fullScreenButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
//                ]
//            }
            
            if let _closeButton = self.closeButton,
                let _titleButton = self.titleButton {
                axConstraints += [
                    _closeButton.widthAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.heightAnchor.constraint(equalToConstant: 32.0),
                    _closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8.0),
                    _closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8.0),
                    
                    _titleButton.leadingAnchor.constraint(equalTo: _closeButton.trailingAnchor, constant: 8.0),
                    _titleButton.centerYAnchor.constraint(equalTo: _closeButton.centerYAnchor),
                    _titleButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0),
                ]
            }
        }
        
        return axConstraints
    }()
    
    public override func playbackSession(_ session: AVPlayer?, didProgressTo progress: TimeInterval) {
        super.playbackSession(session, didProgressTo: progress)
        self.player = session
        
        self.playPauseButton?.player = player
        
        self.rewindButton?.player = player
        self.rewindButton?.progress = progress
        
        self.fastForwardButton?.player = player
        self.fastForwardButton?.progress = progress
        
        self.speedRateButton?.player = player
        
//        self.slider?.player = player
//        self.slider?.progress = progress
        
        self.closeButton?.player = player
        self.closeButton?.videoView = self.videoView
        
        self.previousButton?.player = player
        self.previousButton?.control = videoView
        
        self.nextButton?.player = player
        self.nextButton?.progress = progress
        self.nextButton?.control = videoView
        self.nextButton?.titleButton = self.titleButton
        
        self.playlistButton?.player = player
        self.playlistButton?.control = videoView
        
        self.playlistTable?.player = player
        self.playlistTable?.control = videoView
        
        self.durationStyleButton?.player = player
        self.durationStyleButton?.progress = progress
    }
    
    public override func playbackStyle(_ style: BBTVPlayeriOSControl.playbackStyle?, progress:Double?, duration: Double?) {
        switch style {
        case .Live:
            if let _durationButton = self.durationStyleButton {
                _durationButton.durationLabel.setTitle("", for: .normal)
                _durationButton.durationLabel.isHidden = true
                _durationButton.progress = player?.currentTime().seconds
                _durationButton.player = player
            }
            
            if let _liveStyleButton = self.liveStyleButton {
                _liveStyleButton.liveLabel.setTitle(" LIVE ", for: .normal)
                _liveStyleButton.liveLabel.isHidden = false
            }
            
//            if let _slider = self.slider {
//                _slider.setUpUI(visible: false)
//                _slider.progress = player?.currentTime().seconds
//                _slider.player = player
//            }
            break
        case .VOD:
            if let _durationButton = self.durationStyleButton {
                _durationButton.durationLabel.isHidden = false
                _durationButton.progress = player?.currentTime().seconds
                _durationButton.player = player
                
            }
            if let _liveStyleButton = self.liveStyleButton {
                _liveStyleButton.liveLabel.setTitle("", for: .normal)
                _liveStyleButton.liveLabel.isHidden = true
            }
//            if let _slider = self.slider {
//                _slider.setUpUI(visible: true)
//                _slider.progress = player?.currentTime().seconds
//                _slider.player = player
//            }
            break
        default:
            break
        }
    }
    
    public override func touchPlayList() {
        if (Configure?.playlist.count ?? 0) > 0 {
            if Configure?.isPlaylistMode ?? false {
                Configure?.isPlaylistMode = false
                self.playlistTable?.isHidden = true
                NSLayoutConstraint.deactivate(playlistUIContainerConstraints)
            } else {
                Configure?.isPlaylistMode = true
                self.playlistTable?.isHidden = false
                NSLayoutConstraint.activate(playlistUIContainerConstraints)
                if (Configure?.isPlaylistMode ?? false) {
                    Configure?.updateControlUIwork?.cancel()
                    print("ยกเลิกงาน ")
                    return
                }
            }
        } else {
            self.playlistTable?.isHidden = true
            NSLayoutConstraint.deactivate(playlistUIContainerConstraints)
        }
        print("isPlaylistMode:", Configure?.isPlaylistMode)
    }
    
    public override func touchFullScreen() {
        if Configure?.isFullScreenMode ?? false {
            Configure?.isFullScreenMode = false
        } else {
            Configure?.isFullScreenMode = true
        }
        print("isFullScreenMode:", Configure?.isFullScreenMode)
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
//        if UIDevice.current.orientation.isPortrait {
//            print("isPortrait")
//            NSLayoutConstraint.deactivate(isLandscapeUIContainerConstraints)
//            NSLayoutConstraint.activate(isPortraitUIContainerConstraints)
//        } else {
            print("isLandscape")
            NSLayoutConstraint.deactivate(isPortraitUIContainerConstraints)
            NSLayoutConstraint.activate(isLandscapeUIContainerConstraints)
//        }
    }
}

extension UIView {
    func loadImageBundle(named imageName:String) -> UIImage? {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "BBTVPlayeriOS", withExtension: "bundle")
        {
            let imageBundel = Bundle(url:bundleURL )
            let image = UIImage(named: imageName, in: imageBundel, compatibleWith: nil)
            return image
        }
        return nil
    }
}
