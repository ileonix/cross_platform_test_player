//
//  BBTVPlayeriOSSwiftUIBottomContainerView.swift
//  BBTVPlayeriOS
//
//  Created by Pimmii on 14/5/2563 BE.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUIBottomContainerView: View {
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    
    let dismiss: (() -> Void)?
    
    @ViewBuilder
    public var body: some View {
        VStack {
            HStack(spacing: 8) {
                BBTVPlayeriOSSwiftUILabelView(title: .constant(Utility.formatSecondsToHMS(videoPos * videoDuration)))
                    .frame(minWidth: .zero, maxWidth: 78,alignment: .leading)
                    .background(Color(.blue))
                
//                BBTVPlayeriOSSwiftUISliderView(position: $videoPos)
                
                Button(action: onSpeedActionButton) {
                    Text("x1.0")
                        .frame(width: 30, height: 30)
                        .padding(.top, 10.0)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10.0)
                        .foregroundColor(.black)
                }.background(Color.yellow)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private func sliderEditingChanged() {
        print("-----+ kkkk")
    }
    
    private func onSpeedActionButton() {
        
    }
}

//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//public struct BBTVPlayeriOSSwiftUISliderView: View {
//    @Binding private(set) var position: Double
//
//    public var body: some View {
//        Slider(value: $position, in: 0...1, onEditingChanged: sliderEditingChanged)
//            .foregroundColor(.white)
//            .accentColor(.white)
//    }
//    
//    private func sliderEditingChanged(editingStarted: Bool) {
//    }
//}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct BBTVPlayeriOSSwiftUIBottomContainerView_Previews: PreviewProvider {
    static var previews: some View {
        BBTVPlayeriOSSwiftUIBottomContainerView(videoPos: .constant(0), videoDuration: .constant(10), dismiss: {})
    }
}
#endif
