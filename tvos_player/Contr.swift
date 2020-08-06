//import UIKit
//import BrightcovePlayerSDK
//
//public  struct ContrControlConstants {
//    public static let VisibleDuration: TimeInterval = 5.0
//    public  static let AnimateInDuration: TimeInterval = 0.1
//    public  static let AnimateOutDuraton: TimeInterval = 0.2
//}
//
//public protocol ContrControlsViewControllerFullScreenDelegate: class {
//    func handleEnterFullScreenButtonPressed()
//    func handleExitFullScreenButtonPressed()
//}
//
//public class Contr: UIViewController {
//    public weak var delegate: ContrControlsViewControllerFullScreenDelegate?
//    public weak var currentPlayer: AVPlayer?
//    
//    private var controlsContainer : UIView = UIView()
//    
//    private  var playPauseButton : UIButton = UIButton()
//    
//    private var playheadLabel : UILabel = UILabel()
//    private var playheadSlider : UISlider = UISlider()
//    private var durationLabel : UILabel = UILabel()
//    private var fullscreenButton : UIButton = UIButton()
//    private var externalScreenButton : MPVolumeView =  MPVolumeView()
//    
//    //    @IBOutlet weak private var controlsContainer: UIView!
//    //    @IBOutlet weak private var playPauseButton: UIButton!
//    //    @IBOutlet weak private var playheadLabel: UILabel!
//    //    @IBOutlet weak private var playheadSlider: UISlider!
//    //    @IBOutlet weak private var durationLabel: UILabel!
//    //    @IBOutlet weak private var fullscreenButton: UIView!
//    //    @IBOutlet weak private var externalScreenButton: MPVolumeView!
//    
//    private var controlTimer: Timer?
//    private var playingOnSeek: Bool = false
//    
//    private lazy var numberFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.paddingCharacter = "0"
//        formatter.minimumIntegerDigits = 2
//        return formatter
//    }()
//    
//    // MARK: - View Lifecycle
//    
//    override  public func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Used for hiding and showing the controls.
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
//        tapRecognizer.numberOfTapsRequired = 1
//        tapRecognizer.numberOfTouchesRequired = 1
//        tapRecognizer.delegate = self
//        view.addGestureRecognizer(tapRecognizer)
//        self.setUpView()
//        externalScreenButton.showsRouteButton = true
//        externalScreenButton.showsVolumeSlider = false
//    }
//    
//    
//    func setUpView()  {
//        self.controlsContainer = {
//            let mInitailView : UIView = UIView()
//            
//            self.playPauseButton = {
//                let mInitailView : UIButton = self.playPauseButton
//                mInitailView.setImage(UIImage(named: "Play Button"), for: .normal)
//                mInitailView.setImage(UIImage(named: "Pause Button"), for: .selected)
//                mInitailView.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//                mInitailView.addTarget(self, action: #selector(handlePlayPauseButtonPressed), for: .touchUpInside)
//                //                mInitailVi
////                mInitailView.imageView?.contentMode = .scaleAspectFit
////                mInitailView.backgroundColor = .blue
//                mInitailView.contentHorizontalAlignment  = .fill
//                mInitailView.contentVerticalAlignment =  .fill
//                return mInitailView
//            }()
//            self.playPauseButton.translatesAutoresizingMaskIntoConstraints = false
//            mInitailView.addSubview(self.playPauseButton)
//            self.playPauseButton.centerYAnchor.constraint(equalTo: mInitailView.centerYAnchor).isActive = true
//               self.playPauseButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//             self.playPauseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            self.playPauseButton.leftAnchor.constraint(equalTo: mInitailView.leftAnchor, constant:  8.0).isActive = true
//            
//            self.playheadLabel = {
//                let mInitailView : UILabel =  self.playheadLabel
//                mInitailView.text = "00:00:00"
//                return mInitailView
//            }()
//            self.playheadLabel.sizeToFit()
//            self.playheadLabel.translatesAutoresizingMaskIntoConstraints = false
//            mInitailView.addSubview(self.playheadLabel)
//            self.playheadLabel.centerYAnchor.constraint(equalTo: mInitailView.centerYAnchor).isActive = true
//            self.playheadLabel.leftAnchor.constraint(equalTo:   self.playPauseButton.rightAnchor, constant:  8.0).isActive = true
//            
//            self.playheadSlider = {
//                let mInitailView : UISlider =  self.playheadSlider
//                mInitailView.addTarget(self, action: #selector(self.handlePlayheadSliderTouchBegin), for: .touchDown)
//                 mInitailView.addTarget(self, action: #selector(self.handlePlayheadSliderTouchEnd), for: .touchUpInside)
//                 mInitailView.addTarget(self, action: #selector(self.handlePlayheadSliderTouchEnd), for: .touchUpOutside)
//                  mInitailView.addTarget(self, action: #selector(self.handlePlayheadSliderValueChanged), for: .valueChanged)
//                return mInitailView
//            }()
//            self.playheadSlider.translatesAutoresizingMaskIntoConstraints = false
//            mInitailView.addSubview(self.playheadSlider)
//            self.playheadSlider.centerYAnchor.constraint(equalTo: mInitailView.centerYAnchor).isActive = true
//            self.playheadSlider.leftAnchor.constraint(equalTo:   self.playheadLabel.rightAnchor, constant:  8.0).isActive = true
//            
//            self.durationLabel = {
//                let mInitailView : UILabel = self.durationLabel
//                mInitailView.text = "00:00:00"
//                return mInitailView
//            }()
//            self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
//            mInitailView.addSubview(self.durationLabel)
//            self.durationLabel.centerYAnchor.constraint(equalTo: mInitailView.centerYAnchor).isActive = true
//            self.durationLabel.leftAnchor.constraint(equalTo:   self.playheadSlider.rightAnchor, constant:  8.0).isActive = true
//            
//            self.fullscreenButton = {
//                let mInitailView : UIButton =   self.fullscreenButton
//                mInitailView.setImage(UIImage(named: "icon-expand"), for: .normal)
//                mInitailView.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//                mInitailView.addTarget(self, action: #selector(self.handleFullScreenButtonPressed), for: .touchUpInside)
//                return mInitailView
//            }()
//            self.fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
//            mInitailView.addSubview(self.fullscreenButton)
//            self.fullscreenButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//            self.fullscreenButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            self.fullscreenButton.centerYAnchor.constraint(equalTo: mInitailView.centerYAnchor).isActive = true
//            self.fullscreenButton.leftAnchor.constraint(equalTo:   self.durationLabel.rightAnchor, constant:  8.0).isActive = true
//            
//            self.externalScreenButton = {
//                let mInitailView : MPVolumeView = self.externalScreenButton
//                
//                return mInitailView
//            }()
//            self.externalScreenButton.translatesAutoresizingMaskIntoConstraints = false
//            mInitailView.addSubview(self.externalScreenButton)
//            self.externalScreenButton.centerYAnchor.constraint(equalTo: mInitailView.centerYAnchor).isActive = true
//            self.externalScreenButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//            self.externalScreenButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            self.externalScreenButton.leftAnchor.constraint(equalTo:   self.fullscreenButton.rightAnchor, constant:  8.0).isActive = true
//            self.externalScreenButton.rightAnchor.constraint(equalTo:  mInitailView.rightAnchor, constant:  -8.0).isActive = true
//            
//            return mInitailView
//        }()
//        
////        self.controlsContainer.backgroundColor = .red
//        self.controlsContainer.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.controlsContainer)
//        self.controlsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.controlsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        self.controlsContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        self.controlsContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
//    }
//    
//    // MARK: - Misc
//    
//    @objc private func tapDetected() {
//        if playPauseButton.isSelected {
//            if controlsContainer.alpha == 0.0 {
//                fadeControlsIn()
//            } else if (controlsContainer.alpha == 1.0) {
//                fadeControlsOut()
//            }
//        }
//    }
//    
//    private func fadeControlsIn() {
//        UIView.animate(withDuration: ContrControlConstants.AnimateInDuration, animations: {
//            self.showControls()
//        }) { [weak self](finished: Bool) in
//            if finished {
//                self?.reestablishTimer()
//            }
//        }
//    }
//    
//    @objc private func fadeControlsOut() {
//        UIView.animate(withDuration: ContrControlConstants.AnimateOutDuraton) {
//            self.hideControls()
//        }
//        
//    }
//    
//    private func reestablishTimer() {
//        controlTimer?.invalidate()
//        controlTimer = Timer.scheduledTimer(timeInterval: ContrControlConstants.VisibleDuration, target: self, selector: #selector(fadeControlsOut), userInfo: nil, repeats: false)
//    }
//    
//    private func hideControls() {
//        controlsContainer.alpha = 0.0
//    }
//    
//    private func showControls() {
//        controlsContainer.alpha = 1.0
//        
//    }
//    
//    private func invalidateTimerAndShowControls() {
//        controlTimer?.invalidate()
//        showControls()
//    }
//    
//    private func formatTime(timeInterval: TimeInterval) -> String? {
//        if (timeInterval.isNaN || !timeInterval.isFinite || timeInterval == 0) {
//            return "00:00"
//        }
//        
//        let hours  = floor(timeInterval / 60.0 / 60.0)
//        let minutes = (timeInterval / 60).truncatingRemainder(dividingBy: 60)
//        let seconds = timeInterval.truncatingRemainder(dividingBy: 60)
//        
//        guard let formattedMinutes = numberFormatter.string(from: NSNumber(value: minutes)), let formattedSeconds = numberFormatter.string(from: NSNumber(value: seconds)) else {
//            return nil
//        }
//        
//        return hours > 0 ? "\(hours):\(formattedMinutes):\(formattedSeconds)" : "\(formattedMinutes):\(formattedSeconds)"
//    }
//    
//    // MARK: - IBActions
//    
//    @IBAction func handleFullScreenButtonPressed(_ button: UIButton) {
//        if button.isSelected {
//            button.isSelected = false
//            delegate?.handleExitFullScreenButtonPressed()
//        } else {
//            button.isSelected = true
//            delegate?.handleEnterFullScreenButtonPressed()
//        }
//    }
//    
//    @IBAction func handlePlayheadSliderTouchEnd(_ slider: UISlider) {
//        if let currentTime = currentPlayer?.currentItem {
//            let newCurrentTime = Float64(slider.value) * CMTimeGetSeconds(currentTime.duration)
//            let seekToTime = CMTimeMakeWithSeconds(newCurrentTime, 600)
//            
//            currentPlayer?.seek(to: seekToTime, completionHandler: { [weak self] (finished: Bool) in
//                self?.playingOnSeek = false
//                self?.currentPlayer?.play()
//            })
//        }
//    }
//    
//    @IBAction func handlePlayheadSliderTouchBegin(_ slider: UISlider) {
//        playingOnSeek = playPauseButton.isSelected
//        currentPlayer?.pause()
//    }
//    
//    @IBAction func handlePlayheadSliderValueChanged(_ slider: UISlider) {
//        if let currentTime = currentPlayer?.currentItem {
//            let currentTime = Float64(slider.value) * CMTimeGetSeconds(currentTime.duration)
//            playheadLabel.text = formatTime(timeInterval: currentTime)
//        }
//        
//    }
//    
//    @IBAction func handlePlayPauseButtonPressed(_ button: UIButton) {
//        if button.isSelected {
//            currentPlayer?.pause()
//        } else {
//            currentPlayer?.play()
//        }
//    }
//    
//}
//
//// MARK: - UIGestureRecognizerDelegate
//
//extension Contr: UIGestureRecognizerDelegate {
//    
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        // This makes sure that we don't try and hide the controls if someone is pressing any of the buttons
//        // or slider.
//        
//        guard let view = touch.view else {
//            return true
//        }
//        
//        if ( view.isKind(of: UIButton.classForCoder()) || view.isKind(of: UISlider.classForCoder()) ) {
//            return false
//        }
//        
//        return true
//    }
//    
//}
//
//// MARK: - BCOVPlaybackSessionConsumer
//
//extension Contr: BCOVPlaybackSessionConsumer {
//    
//    public func didAdvance(to session: BCOVPlaybackSession!) {
//        currentPlayer = session.player
//        
//        // Reset State
//        playingOnSeek = false
//        playheadLabel.text = formatTime(timeInterval: 0)
//        playheadSlider.value = 0.0
//        
//        invalidateTimerAndShowControls()
//    }
//    
//    public  func playbackSession(_ session: BCOVPlaybackSession!, didChangeDuration duration: TimeInterval) {
//        durationLabel.text = formatTime(timeInterval: duration)
//    }
//    
//    public func playbackSession(_ session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
//        playheadLabel.text = formatTime(timeInterval: progress)
//        
//        guard let currentItem = session.player.currentItem else {
//            return
//        }
//        
//        let duration = CMTimeGetSeconds(currentItem.duration)
//        let percent = Float(progress / duration)
//        playheadSlider.value = percent.isNaN ? 0.0 : percent
//    }
//    
//    public func playbackSession(_ session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
//        
//        switch lifecycleEvent.eventType {
//        case kBCOVPlaybackSessionLifecycleEventPlay:
//            playPauseButton.isSelected = true
//            reestablishTimer()
//        case kBCOVPlaybackSessionLifecycleEventPause:
//            playPauseButton.isSelected = false
//            invalidateTimerAndShowControls()
//        default:
//            break
//        }
//        
//    }
//    
//}
//
