//
//  AddTaskViewController.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import UIComponents
import RxSwift
import RxCocoa

class AddTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var cellConfigureData = TaskConfigCellModel.defaultValue()
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    override func viewDidLoad() {
        self.title = "新建事项"
        view.backgroundColor = .systemGroupedBackground
        
        isModalInPresentation = true
        
        tableView.register(TaskInputTableViewCell.self, forCellReuseIdentifier: TaskInputTableViewCell.reuseID)
        tableView.register(TaskSwitchTableViewCell.self, forCellReuseIdentifier: TaskSwitchTableViewCell.reuseID)
        tableView.register(TaskNavigationTableViewCell.self, forCellReuseIdentifier: TaskNavigationTableViewCell.reuseID)
        
        configNavigationItem()
        setUpSubViews()
    }
    
    private func configNavigationItem() {
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAddition))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(completeAddition))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setUpSubViews() {
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

extension AddTaskViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TaskConfigCellModel.defaultValue().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskConfigCellModel.defaultValue()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TaskConfigBaseTableViewCell?
        
        switch cellConfigureData[indexPath.section][indexPath.row].type {
            case .input:
                cell = tableView.dequeueReusableCell(withIdentifier: TaskInputTableViewCell.reuseID, for: indexPath) as? TaskInputTableViewCell
            case .switch:
                cell = tableView.dequeueReusableCell(withIdentifier: TaskSwitchTableViewCell.reuseID, for: indexPath) as? TaskSwitchTableViewCell
            case .navigation:
                cell = tableView.dequeueReusableCell(withIdentifier: TaskNavigationTableViewCell.reuseID, for: indexPath) as? TaskNavigationTableViewCell
        }
        cell?.tableView = tableView
        cell?.setIsSeparateLineHidden(indexPath.row == cellConfigureData[indexPath.section].count - 1)
        cell?.configCell(with: cellConfigureData[indexPath.section][indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
}

extension AddTaskViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellConfigureData[indexPath.section][indexPath.row].type {
            case .navigation:
                let controller = ChooseGroupViewController()
                controller.chooseCompleted = { [weak self] title, color in
                    self?.cellConfigureData[indexPath.section][indexPath.row].currentValueLabelText = title
                    self?.cellConfigureData[indexPath.section][indexPath.row].indicatorViewColor = TasksGroupIconColorImpl.plainColor(with: color)
                    tableView.reloadData()
                }
                self.navigationController?.pushViewController(controller, animated: true)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
