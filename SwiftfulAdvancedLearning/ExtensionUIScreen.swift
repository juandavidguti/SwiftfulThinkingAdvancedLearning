//
//  ExtensionUIScreen.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 23/10/25.
//

import SwiftUI

extension UIScreen {
    static var current: UIScreen? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen
    }
}

enum Screen {
    static var size: CGSize  { UIScreen.current?.bounds.size ?? .zero }
    static var width: CGFloat  { size.width }
    static var height: CGFloat { size.height }
}

