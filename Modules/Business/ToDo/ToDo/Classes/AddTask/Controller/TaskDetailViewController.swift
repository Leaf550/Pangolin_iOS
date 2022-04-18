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

enum TaskEditMode {
    case newTask
    case editTask
}

class TaskDetailViewController: UIViewController, ViewController, UITableViewDataSource, UITableViewDelegate {
    
    typealias VM = AddTaskViewModel
 
    var viewModel: VM = AddTaskViewModel()
    
    var disposeBag = DisposeBag()
    
    private lazy var cellConfigureData = TaskConfigCellModel()
    private var taskEditMode: TaskEditMode?
    
    private lazy var indicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    private lazy var taskValue = BehaviorSubject<TaskModel?>(value: defaultTask)
    private lazy var listValue = BehaviorSubject<TaskList?>(value: cellConfigureData.selectedList)
    
    private var defaultTask: TaskModel?
    
    static func addTask(defaultList: TaskList?) -> TaskDetailViewController {
        let controller = TaskDetailViewController(defaultList: defaultList)
        controller.taskEditMode = .newTask
        if let data = "{}".data(using: .utf8) {
            controller.defaultTask = try? JSONDecoder().decode(TaskModel.self, from: data)
        }
        return controller
    }
    
    static func editTask(defaultList: TaskList?, originalTask: TaskModel?) -> TaskDetailViewController {
        let controller = TaskDetailViewController(defaultList: defaultList)
        controller.taskEditMode = .editTask
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
        if taskEditMode == .newTask {
            title = "新建事项"
        } else if taskEditMode == .editTask {
            title = "编辑事项"
        }
        
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
            taskValue,
            listValue.map { $0?.listID ?? "" }
        )
        
        navigationItem.rightBarButtonItem?.rx
            .tap
            .withLatestFrom(data) { $1 }
            .filter { (task, listID) in
                task?.title != nil && task?.title != "" && listID != ""
            }
            .map { [weak self] (task, listID) in
                self?.indicator.startAnimating()
                return (task, listID, self?.taskEditMode ?? .newTask)
            }
            .bind(to: viewModel.input.taskEditCompleted)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.uploadResult
            .subscribe(onNext: { [weak self] uploadedTask, listId in
                self?.indicator.stopAnimating()
                if uploadedTask == nil {
                    Toast.show(text: "网络错误")
                } else {
                    if self?.taskEditMode == .newTask {
                        if let uploadedTask = uploadedTask,
                           let listId = listId {
                            TaskManager.shared.addTask(task: uploadedTask, toListID: listId)
                        }
                    } else {
                        if let uploadedTask = uploadedTask,
                           let listId = listId {
                            TaskManager.shared.deleteTask(withTaskID: uploadedTask.taskID ?? "")
                            TaskManager.shared.addTask(task: uploadedTask, toListID: listId)
                        }
                    }
                    self?.dismiss(animated: true, completion: nil)
                }
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
        
        Observable.combineLatest(
            taskValue,
            listValue
        ) { $0?.title != nil && $0?.title != "" && $1 != nil }
            .bind(to: rightButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func setUpSubViews() {
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
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
        
        guard let cellDisposeBag = cell?.baseCellDisposeBag else { return UITableViewCell() }
        
        switch cellModel.content {
            case .title:
                cell?.textView?.rx
                    .text
                    .withLatestFrom(taskValue) { ($0, $1) }
                    .map { title, task -> TaskModel? in
                        var task = task
                        task?.title = title
                        return task
                    }
                    .bind(to: taskValue)
                    .disposed(by: cellDisposeBag)
            case .comment:
                cell?.textView?.rx
                    .text
                    .withLatestFrom(taskValue) { ($0, $1) }
                    .map { comment, task -> TaskModel? in
                        var task = task
                        task?.comment = comment
                        return task
                    }
                    .bind(to: taskValue)
                    .disposed(by: cellDisposeBag)
            case .date:
                if let isOn = cell?.switch?.rx.isOn,
                   let date = cell?.datePicker?.rx.date {
                    Observable.combineLatest(isOn, date)
                        .withLatestFrom(taskValue) { ($0, $1) }
                        .map { (isOnAndDate, task) -> TaskModel? in
                            let isOn = isOnAndDate.0
                            let date = isOnAndDate.1
                            var task = task
                            if isOn == false {
                                task?.date = nil
                                task?.time = nil
                            } else {
                                let today = (Int(date.timeIntervalSince1970 + 8 * 3600) / (24 * 3600)) * 24 * 3600 - 8 * 3600
                                if let originDate = task?.date,
                                   let originTime = task?.time {
                                    let originDay = (Int(originDate + 8 * 3600) / (24 * 3600)) * 24 * 3600 - 8 * 3600
                                    let diff = today - originDay
                                    let newTime = originTime + Double(diff)
                                    task?.time = newTime
                                }
                                task?.date = Double(today) > 0 ? Double(today) : 0
                            }
                            return task
                        }
                        .bind(to: taskValue)
                        .disposed(by: cellDisposeBag)
                }
            case .time:
                if let isSwitchEnable = cell?.switch?.rx.isEnabled {
                    taskValue
                        .map { task in
                            let shouldEnable = task?.date != nil
                            if !shouldEnable {
                                cell?.`switch`?.isOn = false
                                cell?.datePicker?.isHidden = true
                            }
                            return shouldEnable
                        }
                        .bind(to: isSwitchEnable)
                        .disposed(by: cellDisposeBag)
                }
                if let isOn = cell?.switch?.rx.isOn,
                   let date = cell?.datePicker?.rx.date {
                    Observable.combineLatest(isOn, date)
                        .withLatestFrom(taskValue) { ($0, $1) }
                        .map { (isOnAndTime, task) -> TaskModel? in
                            let isOn = isOnAndTime.0
                            let time = isOnAndTime.1
                            var task = task
                            if isOn == false {
                                task?.time = nil
                            } else {
                                let timeStamp = Int(time.timeIntervalSince1970)
                                task?.time = Double(timeStamp) > 0 ? Double(timeStamp) : 0
                            }
                            return task
                        }
                        .bind(to: taskValue)
                        .disposed(by: cellDisposeBag)
                }
            case .important:
                cell?.`switch`?.rx.isOn
                    .withLatestFrom(taskValue) { isOn, task -> TaskModel? in
                        var task = task
                        task?.isImportant = isOn
                        return task
                    }
                    .bind(to: taskValue)
                    .disposed(by: cellDisposeBag)
            case .list:
                break
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
