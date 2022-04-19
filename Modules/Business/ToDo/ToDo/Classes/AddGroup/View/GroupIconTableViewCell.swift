//
//  GroupIconTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit

class GroupIconTableViewCell: GroupConfigBaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var reuseID: String = NSStringFromClass(GroupIconTableViewCell.self)
    
    private var isFirst = true
    
    override func setUpSubViews() {
        super.setUpSubViews()
        
        let colorViewWidth = 48
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 5
        flowLayout.itemSize = CGSize(width: colorViewWidth, height: colorViewWidth)
        iconCollection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        iconCollection?.backgroundColor = .clear
        iconCollection?.register(GroupIconImageCollectionViewCell.self, forCellWithReuseIdentifier: GroupIconImageCollectionViewCell.reuseID)
        
        iconCollection?.dataSource = self
        iconCollection?.delegate = self
    }

}

extension GroupIconTableViewCell {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6 * 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: GroupIconImageCollectionViewCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupIconImageCollectionViewCell.reuseID, for: indexPath) as? GroupIconImageCollectionViewCell
        cell?.image = UIImage(named: "\(indexPath.item)medium")
        if isFirst {
            cell?.setCellSelected(true)
            isFirst = false
        }
        return cell ?? UICollectionViewCell()
    }
    
}

extension GroupIconTableViewCell {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        didSelectImage("\(indexPath.item)")
    }
    
}
