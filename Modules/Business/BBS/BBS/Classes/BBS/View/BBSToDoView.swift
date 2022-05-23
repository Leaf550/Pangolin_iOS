//
//  BBSToDoView.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/19.
//

import PGFoundation
import UIComponents
import SnapKit

class BBSToDoView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .regular)
        
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .caption0, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var sealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.9
        imageView.image = UIImage(named: "complete_seal")
        
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .caption1, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews(with task: TaskModel?) {
        titleLabel.text = task?.title
        commentLabel.text = task?.comment
        if task?.isCompleted ?? false,
           let completeTime = task?.completeTime {
            let completeTime = Date(timeIntervalSince1970: Double(completeTime))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "zh_CN")
            dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
            let completeDateText = dateFormatter.string(from: completeTime)
            timeLabel.text = completeDateText
            sealImageView.isHidden = false
        } else {
            sealImageView.isHidden = true
        }
        
    }
    
    private func setUpSubviews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.05
        
        addSubview(titleLabel)
        addSubview(commentLabel)
        addSubview(timeLabel)
        addSubview(sealImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        sealImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(20)
            make.height.width.equalTo(80)
        }
    }
    
}
