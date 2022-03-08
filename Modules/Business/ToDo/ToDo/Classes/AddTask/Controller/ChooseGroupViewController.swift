//
//  ChooseListViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import UIComponents

class ChooseGroupViewController: UIViewController {
    
    var chooseCompleted: (_ title: String, _ color: TasksGroupIconColor) -> Void = { _, _ in }
    
    private let groupList = [Int](repeating: 0, count: 10)
    private lazy var groupListRelay = BehaviorRelay<[Int]>(value: groupList)
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        
        groupListRelay
            .bind(to: table.rx.items(cellIdentifier: ChooseGroupTableViewCell.reuseID, cellType: ChooseGroupTableViewCell.self)) { row, data, cell in
                cell.titleLabel.text = String(row)
                if row == 0 {
                    cell.setTickImageHidden(false)
                } else {
                    cell.setTickImageHidden(true)
                }
            }
            .disposed(by: disposeBag)
        
        table.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.chooseCompleted("chosenTitle", .blue)
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "目标列表"
        
        tableView.register(ChooseGroupTableViewCell.self, forCellReuseIdentifier: ChooseGroupTableViewCell.reuseID)
        
        setUpSubViews()
    }
    
    private func setUpSubViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}
