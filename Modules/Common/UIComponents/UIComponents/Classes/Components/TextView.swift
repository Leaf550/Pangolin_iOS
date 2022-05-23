//
//  TextView.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit

public class TextView: UITextView {
    
    public var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    public var placeholderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var font: UIFont? {
        set {
            super.font = newValue
            setNeedsDisplay()
        }
        get {
            super.font
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.placeholderColor = .placeholderText
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc
    func textViewDidChange(notification: Notification) {
        self.setNeedsDisplay()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        if self.hasText {
            return
        }
        
        var attrs = [NSAttributedString.Key : Any]()
        attrs[.font] = self.font
        attrs[.foregroundColor] = self.placeholderColor
        
        let placeholderSize = NSString(string: placeholder ?? "").size(withAttributes: attrs)
        
        var placeholderRect = rect
        placeholderRect.origin.x = 5
        placeholderRect.origin.y = 8
        placeholderRect.size.width -= 2 * rect.origin.x
        
        NSString(string: placeholder ?? "").draw(in: placeholderRect, withAttributes: attrs)
    }
}
