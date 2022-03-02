//
//  ToDoBlock.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit
import SnapKit

public class TopTodoView: UIView {

    private var icon: ToDoTinyIcon
    private var name: String
    private var number: Int
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = name
        label.textColor = .secondaryLabel
        label.font = .textFont(for: .body, weight: .medium)
        
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = String(number)
        label.textColor = .label
        label.font = .textFont(for: .title1, weight: .semibold)
        
        return label
    }()
    
    public init(icon: ToDoTinyIcon, name: String, number: Int) {
        self.icon = icon
        self.name = name
        self.number = number
        super.init(frame: .zero)
        
        backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 12
        
        addSubview(icon)
        addSubview(nameLabel)
        addSubview(numberLabel)
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.trailing.equalToSuperview().offset(-15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
