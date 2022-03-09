//
//  GroupConfigBaseTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import UIComponents
import SnapKit
import Util

class GroupConfigBaseTableViewCell: TableViewCell {
    
    var didSelectColor: (_ color: TasksGroupIconColor) -> Void = { _ in }
    var didSelectImage: (_ image: UIImage) -> Void = { _ in }
    
    var groupIcon: TasksGroupLargeIcon?
    var groupTitleTextTield: UITextField?
    var colorCollection: UICollectionView?
    var iconCollection: UICollectionView?
    
    var selectedIndex: Int = 0 {
        willSet {
            let colorCell = colorCollection?.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? GroupIconBaseCollectionViewCell
            let iconCell = iconCollection?.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? GroupIconBaseCollectionViewCell
            colorCell?.setCellSelected(false)
            iconCell?.setCellSelected(false)
        }
        didSet {
            let colorCell = colorCollection?.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? GroupIconBaseCollectionViewCell
            let iconCell = iconCollection?.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? GroupIconBaseCollectionViewCell
            colorCell?.setCellSelected(true)
            iconCell?.setCellSelected(true)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        style = .withPadding
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    func addSubViewsConstraints() {
        setUpSubViews()
        
        if let groupIcon = groupIcon {
            contentView.addSubview(groupIcon)
        }
        if let groupTitleTextTield = groupTitleTextTield {
            contentView.addSubview(groupTitleTextTield)
        }
        if let colorCollection = colorCollection {
            contentView.addSubview(colorCollection)
        }
        if let iconCollection = iconCollection {
            contentView.addSubview(iconCollection)
        }
        
        if let groupIcon = groupIcon {
            groupIcon.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
            }
            
            groupTitleTextTield?.snp.makeConstraints { make in
                make.height.equalTo(56)
                make.top.equalTo(groupIcon.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(16)
                make.bottom.trailing.equalToSuperview().offset(-16)
            }
        }
        
        colorCollection?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(48)
        }
        
        iconCollection?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo((48 + 5) * 4)
        }
    }
    
}
