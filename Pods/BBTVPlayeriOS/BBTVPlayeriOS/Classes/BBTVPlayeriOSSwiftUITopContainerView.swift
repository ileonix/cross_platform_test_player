//
//  BBTVPlayeriOSSwiftUITopContainerView.swift
//  BBTVPlayeriOS
//
//  Created by Pimmii on 14/5/2563 BE.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUITopContainerView: View {
    @State private(set) var title: String?
    
    let dismiss: (() -> Void)?
    
    @ViewBuilder
    public var body: some View {
        HStack() {
            HStack() {
                if dismiss != nil {
                    BBTVPlayeriOSSwiftUIBottonView(iconName: "multiply", action: self.toggleCloseButton)
                }
                
                if title != nil {
                    BBTVPlayeriOSSwiftUILabelView(title: $title)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            
//            VStack() {
//                BBTVPlayeriOSSwiftUIActionMenuView()
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    func toggleCloseButton() {
        guard let dismiss = dismiss else { return }
        dismiss()
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct BBTVPlayeriOSSwiftUITopContainerView_Previews: PreviewProvider {
    static var previews: some View {
        BBTVPlayeriOSSwiftUITopContainerView(dismiss: { })
    }
}
#endif
