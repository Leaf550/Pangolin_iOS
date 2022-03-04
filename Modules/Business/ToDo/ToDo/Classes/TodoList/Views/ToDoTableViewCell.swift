//
//  ToDoTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/3.
//

import UIKit
import UIComponents
import SnapKit
import RxSwift
import RxCocoa

class ToDoTableViewCell: TableViewCell {
    
    static var reuseID: String = NSStringFromClass(ToDoTableViewCell.self)
    
    var tableView: UITableView?
    
    private let disposeBag = DisposeBag()
    
    lazy var checkBox = CheckBox()
    
    lazy var todoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .textFont(for: .body, weight: .regular)
        textView.textColor = .label
        textView.isScrollEnabled = false
        
        textView.rx.didChange.bind { [weak self] _ in
            let constraintSize = CGSize(width: textView.frame.size.width, height: CGFloat(Int.max))
            var size = textView.sizeThatFits(constraintSize)
            textView.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(size.height)
            }
            self?.tableView?.beginUpdates()
            self?.tableView?.endUpdates()
        }.disposed(by: disposeBag)
        
        return textView
    }()
    
    private lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        line.alpha = 0.5
        return line
    }()
    
    private lazy var flag: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style = .fillEnds
        self.selectionStyle = .none
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(checkBox)
        contentView.addSubview(todoTextView)
        contentView.addSubview(separateLine)
        contentView.addSubview(flag)
        
        checkBox.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
        }
        
        todoTextView.snp.makeConstraints { make in
            make.leading.equalTo(checkBox.snp.trailing).offset(16)
            make.trailing.equalTo(flag.snp.leading)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.greaterThanOrEqualTo(36)
        }
        
        separateLine.snp.makeConstraints { make in
            make.leading.equalTo(todoTextView)
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        flag.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(checkBox)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
