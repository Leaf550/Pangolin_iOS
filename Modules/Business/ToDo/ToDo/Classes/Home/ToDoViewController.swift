//
//  ToDoViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import UIComponents
import SnapKit
import Util
import RxSwift
import RxCocoa

class ToDoViewController: UIViewController {
    
    private var numberOfRows = 20
    
    private var listData = BehaviorSubject<[Int]>(value: [Int](repeating: 0, count: 20))
    
    private let disposeBag = DisposeBag()
    
    private lazy var listsTableView: TableView = {
        let table = TableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = 54
        
        listData
            .bind(to: table.rx.items(cellIdentifier: ToDoListTableViewCell.reuseID, cellType: ToDoListTableViewCell.self)) { [weak self] row, data, cell in
                guard let self = self else { return }
                cell.titleLabel.text = String(row)
                cell.numberLabel.text = "0"
                cell.iconColor = .blue
                cell.hasSeparateLine = (row != self.numberOfRows - 1)
            }
            .disposed(by: disposeBag)
        
        table.rx.itemSelected.bind { [weak self] indexPath in
            let todoListController = ToDoListViewController(titleColor: .blue)
            todoListController.title = String(indexPath.row)
            todoListController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(todoListController, animated: true)
        }.disposed(by: disposeBag)
        
        tableHeaderView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.size.width)
        }
        table.tableHeaderView = tableHeaderView
        table.tableHeaderView?.layoutIfNeeded()
        
        return table
    }()
    
    private lazy var myListTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "我的列表"
        label.font = .textFont(for: .title2, weight: .medium)
        
        return label
    }()
    
    private lazy var tableHeaderView: UIView = {
        let header = UIView()
        let topToDoLists = TopToDoListView()
        header.addSubview(topToDoLists)
        topToDoLists.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        header.addSubview(myListTitleLabel)
        myListTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topToDoLists.snp.bottom)
            make.leading.equalTo(topToDoLists).offset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "列表"
        self.navigationItem.titleView = UIView()
        
        listsTableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.reuseID)
        
        setUpSubView()
    }
    
    private func setUpSubView() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(listsTableView)
        listsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Screen.statusBarHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}
