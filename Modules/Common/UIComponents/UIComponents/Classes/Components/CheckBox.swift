//
//  CheckBox.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/3.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class CheckBox: UIView {
    
    public var checkBoxSelectCallBack: (_ selected: Bool) -> Void = { _ in }
        
    private var isSelected: Bool = false {
        didSet {
            selectView.isHidden = !isSelected
            selectView.backgroundColor = isSelected ? selectedColor : unSelectedColor
            layer.borderColor = (isSelected ? selectedColor : unSelectedColor).cgColor
        }
    }
    
    private let selectedColor = UIColor.systemBlue
    private let unSelectedColor = UIColor.lightGray
    
    private let disposeBag = DisposeBag()
    
    private lazy var selectView: UIView = {
        let view = UIView()
        view.backgroundColor = unSelectedColor
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = unSelectedColor.cgColor
        
        addSubview(selectView)
        selectView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(3)
            make.trailing.bottom.equalToSuperview().offset(-3)
            make.width.height.equalTo(16)
        }
        selectView.layer.cornerRadius = 8
        self.layer.cornerRadius = (16 + 6) * 0.5
        
        setTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setSelect(_ select: Bool) {
        self.isSelected = select
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind { [weak self] _ in
            guard let self = self else { return }
            self.setSelect(!self.isSelected)
            self.checkBoxSelectCallBack(self.isSelected)
        }.disposed(by: disposeBag)
        
        self.addGestureRecognizer(tap)
    }

}
