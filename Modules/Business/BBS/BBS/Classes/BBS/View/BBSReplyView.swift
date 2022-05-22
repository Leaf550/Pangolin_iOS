//
//  BBSReplyView.swift
//  BBS
//
//  Created by 方昱恒 on 2022/3/31.
//

import UIKit
import PGFoundation
import RxSwift
import RxCocoa

class BBSReplyView: UIView {
    
    var didSelectReplyView: (BBSComment) -> Void = { _ in }
    
    private var replieViews = [UIView]()
    private var comments = [BBSComment]()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews(with comments: [BBSComment]) {
        self.comments = comments
        
        for reply in replieViews {
            reply.snp.removeConstraints()
            reply.removeFromSuperview()
        }
        replieViews = []
        layoutIfNeeded()
        
        for comment in comments {
            self.addReply(originUser: comment.sourceUser,
                          targetUser: comment.targetUser,
                     content: comment.content ?? "")
        }
    }
    
    private func addReply(originUser: User?, targetUser: User?, content: String) {
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
        
        replieViews.append(replyView)
        
        for i in 0 ..< replieViews.count {
            let tap = UITapGestureRecognizer()
            tap.rx.event.bind { [weak self] _ in
                guard let self = self else { return }
                self.didSelectReplyView(self.comments[i])
            }.disposed(by: disposeBag)
            
            replieViews[i].gestureRecognizers?.removeAll()
            replieViews[i].addGestureRecognizer(tap)
            
            if replieViews.count == 1 {
                replieViews[i].snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else if i == 0 {
                replieViews[i].snp.remakeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                }
            } else if i == replieViews.count - 1 {
                replieViews[i].snp.remakeConstraints { make in
                    make.top.equalTo(replieViews[i - 1].snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            } else {
                replieViews[i].snp.remakeConstraints { make in
                    make.top.equalTo(replieViews[i - 1].snp.bottom)
                    make.leading.trailing.equalToSuperview()
                }
            }
        }
        
        layoutIfNeeded()
    }

}
