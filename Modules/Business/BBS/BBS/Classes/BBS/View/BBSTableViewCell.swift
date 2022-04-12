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

class BBSTableViewCell: UITableViewCell {
    
    static let reuseID: String = NSStringFromClass(BBSTableViewCell.self)
    
    private lazy var avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.backgroundColor = .gray
        
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
        label.text = "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"
        label.numberOfLines = 0
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var todoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        
        return view
    }()
    
    private lazy var praiseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    private lazy var commentButton: UIView = {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 4
        
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
    
    lazy var replyView = BBSReplyView()
    
    lazy var imageCollection: BBSImageCollection? = BBSImageCollection()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        todoView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(6)
            make.height.equalTo(120)
        }
        
        if let imageCollection = imageCollection {
            imageCollection.snp.makeConstraints { make in
                make.leading.trailing.equalTo(contentLabel)
                make.top.equalTo(todoView.snp.bottom).offset(6)
                make.height.equalTo(BBSImageCollection.imageWidth)
            }
        }
        
        praiseButton.snp.makeConstraints { make in
            if let imageCollection = imageCollection {
                make.top.equalTo(imageCollection.snp.bottom).offset(6)
            } else {
                make.top.equalTo(todoView.snp.bottom).offset(6)
            }
            make.trailing.equalTo(contentLabel)
            make.width.height.equalTo(20)
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
