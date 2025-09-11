//
//  UIApplication+Extensions.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 10.09.2025.
//

import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let root = windowScene.keyWindow?.rootViewController else { return nil }
        var top = root
        while let presented = top.presentedViewController { top = presented }
        return top
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}
