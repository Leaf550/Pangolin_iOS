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
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var shadowView: UIView = {
        let shadow = UIView()
        shadow.layer.shadowColor = UIColor.darkGray.cgColor
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowRadius = 5
        shadow.layer.shadowOpacity = 0.1
        
        return shadow
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(shadowView)
        shadowView.addSubview(imageView)
        
        shadowView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(4)
            make.trailing.bottom.equalToSuperview().offset(-4)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
