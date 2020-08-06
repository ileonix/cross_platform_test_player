//
//  BBTVPlayeriOSSwiftUI.swift
//  BBTVNewPlayers
//
//  Created by Banchai on 21/4/2563 BE.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct NavigationButtonItem: View {
    public var body: some View {
        Button(action: {
            // Actions
        }, label: { Text("Hello World") }).foregroundColor(.red)
    }
}
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct NavigationImageItem: View {
    public var body: some View {
        Button(action: {
            // Actions
            
        }, label: { Text("Edit") })
    }
}
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
 public struct BBTVPlayeriOSSwiftUI: View {
    public init() {}
    public var body: some View {
        NavigationView {
            List {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
//            .navigationBarTitle("Menu", displayMode: .inline)
            .navigationBarItems(
                leading: NavigationButtonItem(),
                trailing: NavigationImageItem()
            )
        }
    }
}
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SwiftUITestView_Previews: PreviewProvider {
    public static var previews: some View {
        BBTVPlayeriOSSwiftUI()
    }
}
#endif

