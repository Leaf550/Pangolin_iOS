//
//  TableViewCell.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit

public enum TableViewCellStyle {
    case fillEnds       // 左右两端占满
    case withPadding    // 左右两端留有空白
}

open class TableViewCell: UITableViewCell {

    public var style: TableViewCellStyle = .withPadding
    
    public override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if style == .fillEnds {
                super.frame = newValue
            } else {
                var frame = newValue
                frame.origin.x += 16
                frame.size.width -= 32
                super.frame = frame
            }
        }
    }

}
