//
//  GroupColorTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import Util
import UIComponents

class GroupColorTableViewCell: GroupConfigBaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var reuseID: String = NSStringFromClass(GroupColorTableViewCell.self)
    
    private var isFirst = true

    override func setUpSubViews() {
        super.setUpSubViews()
        
        let colorViewWidth = 48
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 5
        flowLayout.itemSize = CGSize(width: colorViewWidth, height: colorViewWidth)
        colorCollection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        colorCollection?.backgroundColor = .clear
        colorCollection?.register(GroupColorCollectionViewCell.self, forCellWithReuseIdentifier: GroupColorCollectionViewCell.reuseID)
        
        colorCollection?.dataSource = self
        colorCollection?.delegate = self
    }

}

extension GroupColorTableViewCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupColorCollectionViewCell.reuseID, for: indexPath) as? GroupColorCollectionViewCell
        cell?.color = TasksGroupIconColor(rawValue: indexPath.item) ?? .red
        if isFirst {
            cell?.setCellSelected(true)
            isFirst = false
        }
        return cell ?? UICollectionViewCell()
    }
}

extension GroupColorTableViewCell {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        didSelectColor(TasksGroupIconColor(rawValue: indexPath.item) ?? .red)
    }
}
