//
//  TabBar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 2/6/24.
//

import SwiftUI
import Foundation
import UIKit

struct CustomTabBarAppearance: ViewModifier {
    init() {
        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .white.withAlphaComponent(0.5)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func customTabBar() -> some View {
        self.modifier(CustomTabBarAppearance())
    }
}
