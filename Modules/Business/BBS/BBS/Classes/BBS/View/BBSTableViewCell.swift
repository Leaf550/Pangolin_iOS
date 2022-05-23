//
//  BBSTableViewCell.swift
//  BBS
//
//  Created by 方昱恒 on 2022/3/31.
//

import UIKit
import UIComponents
import Util
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa
import PGFoundation
import Provider

class BBSTableViewCell: UITableViewCell {
    
    static let reuseID: String = NSStringFromClass(BBSTableViewCell.self)
    
    weak var controller: UIViewController?
    var post: BBSPost?
    var didPraise: (String) -> Void = { _ in }
    var didEditReply: (_ postID: String,
                       _ targetUserID: String?,
                       _ content: String) -> Void = { _, _, _  in }
    
    private var disposeBag = DisposeBag()
    
    private lazy var avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "avatar")
        
        return avatar
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "昵称"
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "今天 10:22"
        label.font = .textFont(for: .caption0, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var todoView: BBSToDoView = {
        let view = BBSToDoView()
        
        return view
    }()
    
    private lazy var praiseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "praise"), for: .normal)
        button.setImage(UIImage(named: "praise_light"), for: .selected)
        button.tintColor = .clear
        
        button.rx.tap.bind { [weak self] _ in
            if !button.isSelected {
                button.isSelected = true
                self?.praiseCount += 1
                self?.didPraise(self?.post?.postID ?? "")
            }
        }.disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var praiseCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var commentButton: UIView = {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 4
        button.rx.tap.bind { [weak self] in
            if let post = self?.post {
                self?.replyPopUp(post: post, comment: nil)
            }
            
        }.disposed(by: disposeBag)
        
        let commentLabel = UILabel()
        commentLabel.font = .textFont(for: .caption0, weight: .regular)
        commentLabel.textColor = .secondaryLabel
        commentLabel.text = "评论"
        button.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        return button
    }()
    
    lazy var replyView: BBSReplyView = {
        let view = BBSReplyView()
        view.didSelectReplyView = { [weak self] comment in
            if let post = self?.post {
                self?.replyPopUp(post: post, comment: comment)
            }
        }
        
        return view
    }()
    
    lazy var imageCollection: BBSImageCollection? = {
        let collection = BBSImageCollection()
        
        return collection
    }()
    
    private lazy var praiseCount: Int = 0 {
        didSet {
            self.praiseCountLabel.text = "\(praiseCount)"
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews(with post: BBSPost) {
        self.post = post
        
        contentLabel.text = post.content
        nicknameLabel.text = post.author?.username
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        let timestamp = Double((post.createTime ?? 0))
        formatter.dateFormat = postDateFormatString(timeIntervalSince1970: timestamp)
        timeLabel.text = formatter.string(from: Date(timeIntervalSince1970: timestamp))
        
        if let commentList = post.commentList {
            replyView.configViews(with: commentList)
        }
        
        todoView.configViews(with: post.task)
        if post.task == nil {
            todoView.isHidden = true
            imageCollection?.snp.updateConstraints { make in
                make.top.equalTo(todoView.snp.bottom).offset(-30)
            }
        } else {
            todoView.isHidden = false
            imageCollection?.snp.updateConstraints { make in
                make.top.equalTo(todoView.snp.bottom).offset(20)
            }
        }
        
        imageCollection?.imageUrls = post.imageUrls ?? []
        imageCollection?.controller = self.controller
        
        praiseCount = post.praiseCount ?? 0
        praiseButton.isSelected = post.isPraised ?? false
    }
    
    private func replyPopUp(post: BBSPost?, comment: BBSComment?) {
        guard let postID = post?.postID, checkLogin() else { return }
        let title = "回复\((comment?.sourceUser?.username ?? (post?.author?.username ?? "...")))"
        let popUp = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        popUp.addTextField()
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { [weak self] action in
            if let replyText = popUp.textFields?.first?.text, !replyText.isEmpty {
                self?.didEditReply(postID, comment?.sourceUser?.uid, replyText)
            }
        }
        popUp.addAction(cancelAction)
        popUp.addAction(confirmAction)
        Responder.topViewController?.present(popUp, animated: true)
    }
    
    private func checkLogin() -> Bool {
        let accountService = PGProviderManager.shared.provider { AccountProvider.self }
        if !(accountService?.isLogined() ?? false) {
            let loginAlert = UIAlertController(title: "请先登录", message: "需要登录账号才能评论给哦～", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            let confirmAction = UIAlertAction(title: "确定", style: .default) { [weak self] action in
                if let controller = self?.controller {
                    accountService?.presentLoginViewController(from: controller, animated: true)
                }
            }
            
            loginAlert.addAction(cancelAction)
            loginAlert.addAction(confirmAction)
            Responder.topViewController?.present(loginAlert, animated: true)
            
            return false
        }
        
        return true
    }
    
    private func postDateFormatString(timeIntervalSince1970 timestamp: Double) -> String {
        var formatString = ""
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        let calendar = Calendar.current
        let now = calendar.dateComponents([.year], from: Date())
        let postTime = calendar.dateComponents([.year], from: date)
        let isThisYear = now.year == postTime.year
        if !isThisYear {
            formatString += "yyyy年"
        }
        
        if !calendar.isDateInToday(date) {
            formatString += "MM月dd日"
        }
        
        formatString += "HH:mm"
        
        return formatString
    }
    
    private func setUpSubViews() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(todoView)
        if let imageCollection = imageCollection {
            contentView.addSubview(imageCollection)
        }
        contentView.addSubview(praiseButton)
        contentView.addSubview(praiseCountLabel)
        contentView.addSubview(replyView)
        contentView.addSubview(commentButton)
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        todoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
        }
        
        if let imageCollection = imageCollection {
            imageCollection.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.top.equalTo(todoView.snp.bottom).offset(20)
            }
        }
        
        praiseButton.snp.makeConstraints { make in
            if let imageCollection = imageCollection {
                make.top.equalTo(imageCollection.snp.bottom).offset(6)
            } else {
                make.top.equalTo(todoView.snp.bottom).offset(20)
            }
            make.trailing.equalTo(praiseCountLabel.snp.leading).offset(-3)
            make.width.height.equalTo(20)
        }
        
        praiseCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(praiseButton)
            make.trailing.equalTo(contentLabel)
        }

        replyView.snp.makeConstraints { make in
            make.top.equalTo(praiseButton.snp.bottom).offset(12)
            make.leading.trailing.equalTo(contentLabel)
            make.height.greaterThanOrEqualTo(0)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(replyView.snp.bottom).offset(12)
            make.height.equalTo(30)
            make.leading.trailing.equalTo(contentLabel)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
}
