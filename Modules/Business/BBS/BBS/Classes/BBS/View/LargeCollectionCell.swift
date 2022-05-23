//
//  LargeCollectionCell.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/20.
//

import UIKit

class LargeCollectionCell: UICollectionViewCell {
    
    static let reuseID: String = NSStringFromClass(LargeCollectionCell.self)
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubViews() {
        contentView.backgroundColor = .black
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
