//
//  PlayerViewSwiftUI.swift
//  BBTVPlayeriOS
//
//  Created by Pimmii on 28/4/2563 BE.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlayerViewSwiftUI: View {
    public var onDismiss: (() -> Void)?
    
    public init() {}
    public var body: some View {
        PlayerContainerView(url: URL(string: Common.vdoPath)!, onDismiss: self.dismiss)
    }
    
    func dismiss() {
        guard onDismiss != nil else { return }
        onDismiss!()
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlayerViewSwiftUI_Previews: PreviewProvider {
    public static var previews: some View {
        PlayerViewSwiftUI()
    }
}

#endif
