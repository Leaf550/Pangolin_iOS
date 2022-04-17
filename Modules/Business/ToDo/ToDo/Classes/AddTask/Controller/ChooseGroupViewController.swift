//
//  ChooseListViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import PGFoundation
import SnapKit
import RxSwift
import RxCocoa
import UIComponents

class ChooseGroupViewController: UIViewController {
    
    var didSelectList: (_ selected: TaskList) -> Void = { _ in }
    
    lazy var groupListSubject = ReplaySubject<[TaskList]>.create(bufferSize: 1)
    
    private var selectedList: TaskList
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        
        groupListSubject
            .bind(to: table.rx.items(cellIdentifier: ChooseGroupTableViewCell.reuseID, cellType: ChooseGroupTableViewCell.self)) { [weak self] row, data, cell in
                cell.titleLabel.text = data.listName
                cell.iconColor = TasksGroupIconColor(rawValue: data.listColor ?? 0) ?? .blue
                if data.listID == self?.selectedList.listID {
                    cell.setTickImageHidden(false)
                } else {
                    cell.setTickImageHidden(true)
                }
            }
            .disposed(by: disposeBag)
        
        table.rx
            .itemSelected
            .withLatestFrom(groupListSubject) { ($0, $1) }
            .bind { [weak self] (indexPath, lists) in
                self?.didSelectList(lists[indexPath.row])
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        return table
    }()
    
    init(selected: TaskList) {
        self.selectedList = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
