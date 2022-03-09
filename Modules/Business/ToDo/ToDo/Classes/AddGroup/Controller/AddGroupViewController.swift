//
//  AddGroupViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import UIComponents
import SnapKit
import RxSwift

class AddGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: TableView = {
        let table = TableView()
        
        table.register(GroupTitleTableViewCell.self, forCellReuseIdentifier: GroupTitleTableViewCell.reuseID)
        table.register(GroupColorTableViewCell.self, forCellReuseIdentifier: GroupColorTableViewCell.reuseID)
        table.register(GroupIconTableViewCell.self, forCellReuseIdentifier: GroupIconTableViewCell.reuseID)
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.rx.setDelegate(self).disposed(by: disposeBag)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        setUpSubViews()
    }
    
    private func configNavigationBar() {
        title = "新建列表"
        
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAddition))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(completeAddition))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setUpSubViews() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func cancelAddition() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func completeAddition() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension AddGroupViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GroupConfigBaseTableViewCell?
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupTitleTableViewCell.reuseID, for: indexPath) as? GroupTitleTableViewCell
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupColorTableViewCell.reuseID, for: indexPath) as? GroupColorTableViewCell
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupIconTableViewCell.reuseID, for: indexPath) as? GroupIconTableViewCell
        }
        
        cell?.didSelectColor = { color in
            let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupTitleTableViewCell
            titleCell?.groupIcon?.color = color
            titleCell?.textFieldTextColor = color
        }
        
        cell?.didSelectImage = { image in
            let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupTitleTableViewCell
            titleCell?.groupIcon?.image = image
        }
        
        return cell ?? UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate
extension AddGroupViewController {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
}
