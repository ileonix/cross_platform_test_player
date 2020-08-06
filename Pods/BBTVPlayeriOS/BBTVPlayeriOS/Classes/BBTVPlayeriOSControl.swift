import AVFoundation
import AVKit
import UIKit

public protocol BBTVPlayeriOSControlDelegate {
    func playbackSession(_ session: AVPlayer?, didProgressTo progress: TimeInterval)
    func playbackStyle(_ style: BBTVPlayeriOSControl.playbackStyle?, progress:Double?, duration: Double?)
    func touchPlayList()
    func touchFullScreen()
}

public class BBTVPlayeriOSControl: UIViewController , BBTVPlayeriOSControlDelegate {
    
    public  enum playbackStyle {
        case Live
        case VOD
        case unowned
    }
    
    public var isPlayList: Bool {
        return (self.Configure?.playlist.count ?? 0) > 1
    }
    
    public var fadeHideView: UIView = UIView()
    public var noFadeHideView: UIView = UIView()
    public var Configure : BBTVPlayeriOSConfigure?
    public var player: AVPlayer?
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        noFadeHideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noFadeHideView)
        noFadeHideView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        noFadeHideView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        noFadeHideView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        noFadeHideView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        fadeHideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fadeHideView)
        fadeHideView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fadeHideView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        fadeHideView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        fadeHideView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    public func playbackSession(_ session: AVPlayer?, didProgressTo progress: TimeInterval) {}
    public func playbackStyle(_ style: BBTVPlayeriOSControl.playbackStyle?, progress:Double?, duration: Double?) {}
    public func touchPlayList() {}
    public func touchFullScreen() {}
}

