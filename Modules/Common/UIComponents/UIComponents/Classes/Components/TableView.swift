//
//  TableView.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit
import RxSwift
import RxCocoa

public enum TableViewSectionStyle {
    case roundCorner        // 圆角section
    case squareCorner       // 直角section
}

public class TableView: UITableView, UITableViewDelegate {
    
    public var sectionStyle: TableViewSectionStyle = .roundCorner
    
    private let disposeBag = DisposeBag()

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configDefaultDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configDefaultDelegate() {
        
        self.rx.willDisplayCell.bind { [weak self] event in
            guard let self = self else { return }
            
            if self.sectionStyle == .squareCorner {
                return
            }
            
            let numberOfRows = self.dataSource?.tableView(self, numberOfRowsInSection: event.indexPath.section) ?? 0
            if numberOfRows == 1 {
                event.cell.setRoundCorner(at: .allCorners, withRadius: 12)
            } else if event.indexPath.row == 0 {
                event.cell.setRoundCorner(at: [.topLeft, .topRight], withRadius: 12)
            } else if event.indexPath.row == numberOfRows - 1 {
                event.cell.setRoundCorner(at: [.bottomLeft, .bottomRight], withRadius: 12)
            } else {
                event.cell.setRoundCorner(at: .allCorners, withRadius: 0)
            }
        }.disposed(by: disposeBag)
        
    }
    
}
