//
//  BBSImageCollection.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/12.
//

import UIKit
import PGFoundation
import Util
import SnapKit

class BBSImageCollection: UIView, UICollectionViewDataSource {
     
    static var imageWidth = (Screen.screenWidth - 24) / 4.0 - 3
    
    private lazy var imageCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        let imageWidth = BBSImageCollection.imageWidth
        flowLayout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
 
        collection.register(BBSImageCollectionCell.self, forCellWithReuseIdentifier: BBSImageCollectionCell.reuserID)
        collection.dataSource = self
        
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageCollection)
        imageCollection.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BBSImageCollection {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BBSImageCollectionCell.reuserID, for: indexPath) as? BBSImageCollectionCell
        
        cell?.backgroundColor = .red
        
        return cell ?? UICollectionViewCell()
    }
    
}
