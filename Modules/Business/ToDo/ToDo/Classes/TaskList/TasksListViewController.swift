//
//  TasksListViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/3.
//

import UIKit
import PGFoundation
import UIComponents
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class TasksListViewController: UIViewController, ViewController, UITableViewDelegate {
    
    typealias VM = TasksListViewModel
    var viewModel = TasksListViewModel()
    var disposeBag = DisposeBag()
    
    var titleColor: TasksGroupIconColor
    var listId: String
    
    private var datasList = [TasksListSection]()
    lazy var sections = BehaviorSubject<[TasksListSection]>(value: datasList)
    
    private lazy var todoTable: TableView = {
        let table = TableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.sectionStyle = .squareCorner
        table.delegate = self
        
        let datasource = RxTableViewSectionedAnimatedDataSource<TasksListSection>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                guard let self = self else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath) as? TaskTableViewCell
                cell?.tableView = tableView
                
                cell?.configData(with: item)
                
                cell?.checkBox.checkBoxSelectCallBack = { selected in
                    var index = 0
                    for i in 0 ..< self.datasList[indexPath.section].items.count {
                        if self.datasList[indexPath.section].items[i].taskID == cell?.taskID ?? "" {
                            index = i
                        }
                    }
                    if selected {
                        var removed = self.datasList[indexPath.section].tasks.remove(at: index)
                        removed.isCompleted = selected
                        self.datasList[indexPath.section].tasks.append(removed)
                        self.datasList[indexPath.section] = TasksListSection(
                            original: self.datasList[indexPath.section],
                            items: self.datasList[indexPath.section].items
                        )
                        self.sections.onNext(self.datasList)
                    } else {
                        var removed = self.datasList[indexPath.section].tasks.remove(at: index)
                        removed.isCompleted = selected
                        var has = false
                        for i in 0 ..< self.datasList[indexPath.section].items.count {
                            let task = self.datasList[indexPath.section].items[i]
                            if task.createTime ?? 0 > removed.createTime ?? 0 {
                                self.datasList[indexPath.section].tasks.insert(removed, at: i)
                                has = true
                                break
                            }
                        }
                        if !has {
                            self.datasList[indexPath.section].tasks.append(removed)
                        }
                        self.datasList[indexPath.section] = TasksListSection(
                            original: self.datasList[indexPath.section],
                            items: self.datasList[indexPath.section].items
                        )
                        self.sections.onNext(self.datasList)
                    }
                }
                return cell ?? UITableViewCell()
            })
        
        datasource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        sections.bind(to: table.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        table.rx.didScroll.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        return table
    }()
    
    init(titleColor: TasksGroupIconColor, listId: String, title: String) {
        self.titleColor = titleColor
        self.listId = listId
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTable.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        
        setUpSubviews()
        bindViewModel()
        
        viewModel.input.viewDidLoadWithListId.onNext(listId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : TasksGroupIconColorImpl.plainColor(with: titleColor)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bindViewModel() {
        let output = viewModel.transformToOutput()
        
        output.tasksListModel
            .map { $0?.data?.sections ?? [] }
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        sections.subscribe(onNext: { [weak self] section in
            self?.datasList = section
        }).disposed(by: disposeBag)
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(todoTable)
        todoTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let buttonItem = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(addToDo))
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc
    func addToDo() {
        let newTaskController = AddTaskViewController()
        let navController = UINavigationController(rootViewController: newTaskController)
        present(navController, animated: true, completion: nil)
    }
    
}

extension TasksListViewController {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "test"
//        label.backgroundColor = .red
//        return label
//    }
}
