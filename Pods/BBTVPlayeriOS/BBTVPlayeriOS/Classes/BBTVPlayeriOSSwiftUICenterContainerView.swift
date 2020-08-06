//
//  BBTVPlayeriOSSwiftUICenterContainerView.swift
//  BBTVPlayeriOS
//
//  Created by Pimmii on 14/5/2563 BE.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUICenterContainerView: View {
    public var body: some View {
        ZStack() {
            // MARK: Player control container
            HStack(alignment: .center, spacing: 8) {
                BBTVPlayeriOSSwiftUIBackwardView(padding: 10)
                    .background(Color(.red))
                    .frame(minWidth: .zero, maxWidth: .infinity)
                
                BBTVPlayeriOSSwiftUIPlayPauseView(padding: 10)
                    .background(Color(.blue))
                    .frame(minWidth: .zero, maxWidth: .infinity)
                
                BBTVPlayeriOSSwiftUIForwardView(padding: 10)
                    .background(Color(.orange))
                    .frame(minWidth: .zero, maxWidth: .infinity)
            }
            .frame(minWidth: .zero, maxWidth: 300, alignment: .center)
//            .background(Color(.yellow))
        }
        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .center)
//        .background(Color(.white))
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUIPlayPauseView: View {
    @State private(set) var iconName: String?
    @State private(set) var padding: CGFloat?
    
    var action: (() -> Void)?
    
    public var body: some View {
        Button(action: toggleButton) {
            Image(systemName: iconName ?? "play.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.top, padding ?? .zero)
                .padding(.leading, padding ?? .zero)
                .padding(.trailing, padding ?? .zero)
                .padding(.bottom, padding ?? .zero)
                .foregroundColor(.white)
        }
    }
    
    private func toggleButton() {
        
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUIForwardView: View {
    @State private(set) var iconName: String?
    @State private(set) var padding: CGFloat?
    
    var action: (() -> Void)?
    
    public var body: some View {
        Button(action: toggleButton) {
            Image(systemName: iconName ?? "goforward")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.top, padding ?? .zero)
                .padding(.leading, padding ?? .zero)
                .padding(.trailing, padding ?? .zero)
                .padding(.bottom, padding ?? .zero)
                .foregroundColor(.white)
        }
    }
    
    private func toggleButton() {
        
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUIBackwardView: View {
    @State private(set) var iconName: String?
    @State private(set) var padding: CGFloat?
    
    var action: (() -> Void)?
    
    public var body: some View {
        Button(action: toggleButton) {
            Image(systemName: iconName ?? "gobackward")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.top, padding ?? .zero)
                .padding(.leading, padding ?? .zero)
                .padding(.trailing, padding ?? .zero)
                .padding(.bottom, padding ?? .zero)
                .foregroundColor(.white)
        }
    }
    
    private func toggleButton() {
        
    }
}


@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct BBTVPlayeriOSSwiftUICenterContainerView_Previews: PreviewProvider {
    static var previews: some View {
        BBTVPlayeriOSSwiftUICenterContainerView()
    }
}
#endif
