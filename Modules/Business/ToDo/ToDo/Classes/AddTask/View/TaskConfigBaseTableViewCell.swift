//
//  TaskConfigBaseTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents
import SnapKit
import RxSwift

class TaskConfigBaseTableViewCell: TableViewCell {
    var contentType: AddTaskCellContent?
    
    var textView: TextView?
    var titleLabel: UILabel?
    var imageBackground: UIView?
    var iconImageView: UIImageView?
    var `switch`: UISwitch?
    var datePicker: UIDatePicker?
    var currentValueLabel: UILabel?
    var indicatorView: UIView?
    var arrowImageView: UIImageView?
    
    var tableView: UITableView?
    var baseCellDisposeBag = DisposeBag()
    
    lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.style = .fillEnds
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        baseCellDisposeBag = DisposeBag()
    }
    
    func setIsSeparateLineHidden(_ hidden: Bool) {
        separateLine.isHidden = hidden
    }
    
    func setUpSubViews() {
        fatalError("setUpSubViews() has not been implemented")
    }
    
    func configCell(with model: TaskConfigCellModel) {
        contentType = model.content
        textView?.text = model.textViewText
        textView?.placeholder = model.inputPlaceholder
        titleLabel?.text = model.titleLabelText
        imageBackground?.backgroundColor = model.iconColor
        iconImageView?.image = model.iconImage
        `switch`?.isOn = model.switchStatus ?? false
        currentValueLabel?.text = model.currentValueLabelText
        indicatorView?.backgroundColor = model.indicatorViewColor
        if model.content == .date {
            datePicker?.datePickerMode = .date
            datePicker?.isHidden = !(`switch`?.isOn ?? false)
            datePicker?.date = Date(timeIntervalSince1970: model.date ?? Date().timeIntervalSince1970)
        } else if model.content == .time {
            datePicker?.datePickerMode = .time
            datePicker?.isHidden = !(`switch`?.isOn ?? false)
            datePicker?.date = Date(timeIntervalSince1970: model.time ?? Date().timeIntervalSince1970)
        } else {
            datePicker?.isHidden = true
        }
    }
    
}
