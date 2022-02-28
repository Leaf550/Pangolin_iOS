//
//  Toast.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/1.
//

import UIKit
import Toast_Swift
import Util

public class Toast {

    public static func show(text: String, image: UIImage? = nil) {
        if text.isEmpty && image == nil {
            return
        }
        guard let topVC = Responder.topViewController else { return }
        topVC.view.makeToast(text, duration: 1, position: .center, image: image)
    }

}
