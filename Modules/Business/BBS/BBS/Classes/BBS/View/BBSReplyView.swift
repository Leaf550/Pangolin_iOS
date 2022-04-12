//
//  BBSReplyView.swift
//  BBS
//
//  Created by 方昱恒 on 2022/3/31.
//

import UIKit
import PGFoundation

class BBSReplyView: UIView {
    
    private var replies = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let u1 = UserImpl(sub: "", username: "u1", level: nil, experience: nil, exp: nil)
        let u2 = UserImpl(sub: "", username: "u2", level: nil, experience: nil, exp: nil)
        let u3 = UserImpl(sub: "", username: "u3", level: nil, experience: nil, exp: nil)
        
        addReply(originUser: u1, targetUser: nil, content: "test11")
        addReply(originUser: u2, targetUser: u1, content: "test2")
        addReply(originUser: u3, targetUser: u2, content: "test2123123")
        addReply(originUser: u3, targetUser: nil, content: "啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addReply(originUser: User?, targetUser: User?, content: String) {
        var replyString = "\(originUser?.username ?? "")"
        replyString += (targetUser != nil ? " 回复 \(targetUser?.username ?? "")：\(content)" : "：\(content)")
        let attributedreplyString = NSMutableAttributedString(string: replyString)
        
        // originUserName 加粗
        attributedreplyString.addAttribute(
            .font,
            value: UIFont.textFont(for: .caption0, weight: .medium),
            range: .init(location: 0, length: originUser?.username?.count ?? 0)
        )
        
        if targetUser != nil {
            // “回复”二字
            attributedreplyString.addAttribute(
                .font,
                value: UIFont.textFont(for: .caption0, weight: .regular),
                range: .init(location: originUser?.username?.count ?? 0, length: 4)
            )
            // targetUserName 加粗
            attributedreplyString.addAttribute(
                .font,
                value: UIFont.textFont(for: .caption0, weight: .medium),
                range: .init(location: (originUser?.username?.count ?? 0) + 4, length: targetUser?.username?.count ?? 0)
            )
            // 回复内容
            attributedreplyString.addAttribute(
                .font,
                value: UIFont.textFont(for: .caption0, weight: .regular),
                range: .init(location: (originUser?.username?.count ?? 0) + 4 + (targetUser?.username?.count ?? 0), length: 1 + content.count)
            )
            // 颜色
            attributedreplyString.addAttribute(
                .foregroundColor,
                value: UIColor.label,
                range: .init(location: 0, length: (originUser?.username?.count ?? 0) + 4 + (targetUser?.username?.count ?? 0) + content.count)
            )
        } else {
            // 回复内容
            attributedreplyString.addAttribute(
                .font,
                value: UIFont.textFont(for: .caption0, weight: .regular),
                range: .init(location: (originUser?.username?.count ?? 0), length: 1 + content.count)
            )
            // 颜色
            attributedreplyString.addAttribute(
                .foregroundColor,
                value: UIColor.label,
                range: .init(location: 0, length: (originUser?.username?.count ?? 0) + 1 + content.count)
            )
        }
        
        
        let replyView = UIView()
        addSubview(replyView)
        
        let replyContentLabel = UILabel()
        replyContentLabel.textColor = .label
        replyContentLabel.numberOfLines = 0
        replyContentLabel.attributedText = attributedreplyString
        
        replyView.addSubview(replyContentLabel)
        
        replyContentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        replies.append(replyView)
        
        for i in 0 ..< replies.count {
            if replies.count == 1 {
                replies[i].snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else if i == 0 {
                replies[i].snp.remakeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                }
            } else if i == replies.count - 1 {
                replies[i].snp.remakeConstraints { make in
                    make.top.equalTo(replies[i - 1].snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            } else {
                replies[i].snp.remakeConstraints { make in
                    make.top.equalTo(replies[i - 1].snp.bottom)
                    make.leading.trailing.equalToSuperview()
                }
            }
        }
        
        layoutIfNeeded()
    }

}
