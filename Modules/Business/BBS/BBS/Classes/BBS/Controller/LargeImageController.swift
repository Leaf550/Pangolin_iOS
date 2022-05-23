//
//  LargImageController.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/20.
//

import UIKit
import Util
import RxSwift
import RxCocoa

class LargeImageController: UIViewController, UICollectionViewDataSource {
    
    private var images: [UIImage]
    private var initialIndex: Int
    
    private var disposeBag = DisposeBag()
    
    private lazy var largeImageCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.isPagingEnabled = true
        collection.register(LargeCollectionCell.self, forCellWithReuseIdentifier: LargeCollectionCell.reuseID)
        collection.dataSource = self
        
        return collection
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "close"), for: .normal)
        button.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSubViews()
    }
    
    init(images: [UIImage], startAt index: Int) {
        self.images = images
        self.initialIndex = index < images.count ? index : images.count - 1
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubViews() {
        view.backgroundColor = .black
        
        view.addSubview(largeImageCollection)
        view.addSubview(closeButton)
        
        largeImageCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(Screen.statusBarHeight + 20)
            make.height.width.equalTo(20)
        }
    }
    
}

extension LargeImageController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCollectionCell.reuseID, for: indexPath) as? LargeCollectionCell
        
        cell?.image = images[indexPath.item]
        
        return cell ?? UICollectionViewCell()
    }
    
}
