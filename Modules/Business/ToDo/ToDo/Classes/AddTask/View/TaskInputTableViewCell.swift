//
//  TaskInputTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents
import SnapKit
import RxSwift
import RxCocoa

class TaskInputTableViewCell: TaskConfigBaseTableViewCell {
    
    static var reuseID: String = NSStringFromClass(TaskInputTableViewCell.self)
    
    private let disposeBag = DisposeBag()
    
    override func setUpSubViews() {
        textView = TextView()
        textView?.placeholder = "test"
        textView?.backgroundColor = .clear
        textView?.font = .textFont(for: .body, weight: .regular)
        textView?.textColor = .label
        textView?.isScrollEnabled = false
        
        textView?.rx.didChange.bind { [weak self] _ in
            let constraintSize = CGSize(width: self?.textView?.frame.size.width ?? 0, height: CGFloat(Int.max))
            let size: CGSize = self?.textView?.sizeThatFits(constraintSize) ?? .zero
            self?.textView?.snp.updateConstraints { make in
                make.height.equalTo(size.height)
            }
            self?.tableView?.beginUpdates()
            self?.tableView?.endUpdates()
        }.disposed(by: disposeBag)
        
        if let input = textView {
            contentView.addSubview(input)
        }
        
        textView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(38)
        }
        
        contentView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            if let textView = textView {
                make.leading.equalTo(textView)
            } else {
                make.leading.equalToSuperview().offset(16)
            }
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}
