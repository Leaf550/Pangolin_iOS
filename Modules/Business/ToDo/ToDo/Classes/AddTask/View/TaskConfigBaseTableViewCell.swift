//
//  TaskConfigBaseTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents
import SnapKit

class TaskConfigBaseTableViewCell: TableViewCell {
    
    var textView: TextView?
    var titleLabel: UILabel?
    var iconImageView: UIImageView?
    var `switch`: UISwitch?
    var currentValueLabel: UILabel?
    var indicatorView: UIView?
    var arrowImageView: UIImageView?
    
    var tableView: UITableView?
    
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
    
    func setIsSeparateLineHidden(_ hidden: Bool) {
        separateLine.isHidden = hidden
    }
    
    func setUpSubViews() {
        fatalError("setUpSubViews() has not been implemented")
    }
    
    func configCell(with model: TaskConfigCellModel) {
        textView?.placeholder = model.inputPlaceholder
        titleLabel?.text = model.titleLabelText
        iconImageView?.backgroundColor = model.iconColor
        iconImageView?.image = model.iconImage
        `switch`?.isOn = model.switchStatus ?? false
        currentValueLabel?.text = model.currentValueLabelText
        indicatorView?.backgroundColor = model.indicatorViewColor
    }
    
}
