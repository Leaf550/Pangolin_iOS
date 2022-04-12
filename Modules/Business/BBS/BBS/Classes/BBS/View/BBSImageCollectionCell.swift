//
//  BBSImageCollectionCell.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/12.
//

import UIKit
import SnapKit

class BBSImageCollectionCell: UICollectionViewCell {
    
    static let reuserID: String = NSStringFromClass(BBSImageCollectionCell.self)
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
