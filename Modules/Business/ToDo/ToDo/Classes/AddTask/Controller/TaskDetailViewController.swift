//
//  TaskDetailViewController.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import UIComponents
import RxSwift
import RxCocoa
import PGFoundation
import Persistence
import Provider

class TaskDetailViewController: UIViewController, ViewController, UITableViewDataSource, UITableViewDelegate {
    
    typealias VM = AddTaskViewModel
 
    var viewModel: VM = AddTaskViewModel()
    
    private lazy var cellConfigureData = TaskConfigCellModel()
    
    var disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    private lazy var titleValue = BehaviorSubject<String?>(value: nil)
    private lazy var commentValue = BehaviorSubject<String?>(value: nil)
    private lazy var dateValue = BehaviorSubject<Double?>(value: nil)
    private lazy var timeValue = BehaviorSubject<Double?>(value: nil)
    private lazy var isImportantValue = BehaviorSubject<Bool>(value: false)
    private lazy var listValue = BehaviorSubject<TaskList?>(value: cellConfigureData.selectedList)
    
    private var defaultTask: TaskModel?
    
    static func addTask(defaultList: TaskList?) -> TaskDetailViewController {
        let controller = TaskDetailViewController(defaultList: defaultList)
        controller.title = "新建事项"
        return controller
    }
    
    static func editTask(defaultList: TaskList?, originalTask: TaskModel?) -> TaskDetailViewController {
        let controller = TaskDetailViewController(defaultList: defaultList)
        controller.title = "修改事项"
        controller.defaultTask = originalTask
        return controller
    }
    
    init(defaultList: TaskList?) {
        super.init(nibName: nil, bundle: nil)
        
        if defaultList != nil {
            cellConfigureData.selectedList = defaultList
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGroupedBackground
        
        isModalInPresentation = true
        
        tableView.register(TaskInputTableViewCell.self, forCellReuseIdentifier: TaskInputTableViewCell.reuseID)
        tableView.register(TaskSwitchTableViewCell.self, forCellReuseIdentifier: TaskSwitchTableViewCell.reuseID)
        tableView.register(TaskNavigationTableViewCell.self, forCellReuseIdentifier: TaskNavigationTableViewCell.reuseID)
        
        configNavigationItem()
        setUpSubViews()
        bindViewModel()
    }
    
    func bindViewModel() {
        let data = Observable.combineLatest(
            titleValue.map { $0 ?? "" },
            commentValue,
            dateValue.map { Int64(($0 ?? 0) * 1000) },
            timeValue.map { Int64(($0 ?? 0) * 1000) },
            isImportantValue,
            listValue.map { $0?.listID ?? "" }
        )
        
        navigationItem.rightBarButtonItem?.rx
            .tap
            .withLatestFrom(data) { $1 }
            .filter { $0 != "" && $5 != "" }
            .bind(to: viewModel.input.completeButtonTap)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.uploadResult
            .subscribe(onNext: { isSuccess in
                print(isSuccess)
            })
            .disposed(by: disposeBag)
    }
    
    private func configNavigationItem() {
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "完成", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
        
        leftButton.rx.tap.bind {
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        rightButton.rx.tap.bind {
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(
            titleValue,
            listValue
        ) { $0 != nil && $0 != "" && $1 != nil }
        .bind(to: rightButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
    private func setUpSubViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension TaskDetailViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellConfigureData.defaultValue(task: defaultTask).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigureData.defaultValue(task: defaultTask)[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TaskConfigBaseTableViewCell?
        let allCellModels = cellConfigureData.defaultValue(task: defaultTask)[indexPath.section]
        let cellModel = cellConfigureData.defaultValue(task: defaultTask)[indexPath.section][indexPath.row]
        
        switch cellModel.type {
            case .input:
                cell = tableView.dequeueReusableCell(withIdentifier: TaskInputTableViewCell.reuseID, for: indexPath) as? TaskInputTableViewCell
            case .switch:
                cell = tableView.dequeueReusableCell(withIdentifier: TaskSwitchTableViewCell.reuseID, for: indexPath) as? TaskSwitchTableViewCell
            case .navigation:
                cell = tableView.dequeueReusableCell(withIdentifier: TaskNavigationTableViewCell.reuseID, for: indexPath) as? TaskNavigationTableViewCell
        }
        cell?.tableView = tableView
        cell?.setIsSeparateLineHidden(indexPath.row == allCellModels.count - 1)
        cell?.configCell(with: cellModel)
        
        switch cellModel.content {
            case .title:
                cell?.textView?.rx
                    .text
                    .bind(to: titleValue)
                    .disposed(by: disposeBag)
            case .comment:
                cell?.textView?.rx
                    .text
                    .bind(to: commentValue)
                    .disposed(by: disposeBag)
            case .date: break
            case .time: break
            case .important:
                cell?.switch?.rx
                    .isOn
                    .bind(to: isImportantValue)
                    .disposed(by: disposeBag)
            case .list: break
        }
        
        return cell ?? UITableViewCell()
    }
    
}

extension TaskDetailViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellConfigureData.defaultValue(task: defaultTask)[indexPath.section][indexPath.row].type {
            case .navigation:
                guard let selectedList = self.cellConfigureData.selectedList else { return }
                let controller = ChooseGroupViewController(selected: selectedList)
                controller.groupListSubject.onNext(self.cellConfigureData.savedTaskLists ?? [])
                controller.didSelectList = { [weak self] selectedList in
                    self?.cellConfigureData.defaultValue(task: self?.defaultTask)[indexPath.section][indexPath.row].currentValueLabelText = selectedList.listName
                    let color = TasksGroupIconColor(rawValue: selectedList.listColor ?? 0) ?? .blue
                    self?.cellConfigureData.defaultValue(task: self?.defaultTask)[indexPath.section][indexPath.row].indicatorViewColor = TasksGroupIconColorImpl.plainColor(with: color)
                    tableView.reloadData()
                    self?.cellConfigureData.selectedList = selectedList
                    self?.listValue.onNext(selectedList)
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
