//
//  TextField.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

import UIKit
import SnapKit

public class TextField: UITextField {
    
    private lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        
        return line
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separateLine)
        
        separateLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
