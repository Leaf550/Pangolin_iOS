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

enum ListType {
    case today
    case important
    case all
    case completed
    case other(String)
}

class TasksListViewController: UIViewController, ViewController, UITableViewDelegate {
    
    typealias VM = TasksListViewModel
    var viewModel = TasksListViewModel()
    var disposeBag = DisposeBag()
    
    var titleColor: TasksGroupIconColor
    var listId: String?
    
    var pageData: ListPageData
    
    lazy var rxSections = ReplaySubject<[TasksListSection]>.create(bufferSize: 1)
    
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
                    guard var section = self.pageData.sections?[indexPath.section] else { return }
                    for i in 0 ..< section.items.count {
                        if section.items[i].taskID == cell?.taskID ?? "" {
                            index = i
                        }
                    }
                    guard var tasks = section.tasks else { return }
                    if selected {
                        var removed = tasks.remove(at: index)
                        removed.isCompleted = selected
                        tasks.append(removed)
                        section.tasks = tasks
                        self.pageData.sections?[indexPath.section] = TasksListSection(
                            original: section,
                            items: tasks
                        )
                        self.rxSections.onNext(self.pageData.sections ?? [])
                    } else {
                        var removed = tasks.remove(at: index)
                        removed.isCompleted = selected
                        var insertIndex: Int? = nil
                        for i in 0 ..< tasks.count {
                            let task = tasks[i]
                            if task.createTime ?? 0 > removed.createTime ?? 0 {
                                insertIndex = i
                                break
                            }
                        }
                        if insertIndex == nil {
                            tasks.append(removed)
                        } else {
                            tasks.insert(removed, at: insertIndex ?? 0)
                        }
                        self.pageData.sections?[indexPath.section] = TasksListSection(
                            original: section,
                            items: tasks
                        )
                        self.rxSections.onNext(self.pageData.sections ?? [])
                    }
                }
                return cell ?? UITableViewCell()
            })
        
        datasource.titleForHeaderInSection = { ds, index in
            if ds.sectionModels.count == 1 {
                return nil
            }
            return ds.sectionModels[index].taskList?.listName ?? ""
        }
        
        rxSections
            .bind(to: table.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        table.rx.didScroll.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        return table
    }()
    
    init(titleColor: TasksGroupIconColor,
         title: String,
         pageData: ListPageData) {
        self.titleColor = titleColor
        self.pageData = pageData
        super.init(nibName: nil, bundle: nil)
        self.title = title
        
        rxSections.onNext(pageData.sections ?? [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTable.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        
        setUpSubviews()
        bindViewModel()
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
//        let output = viewModel.transformToOutput()
//
//        output.tasksListModel
//            .map { $0?.data?.rxSections ?? [] }
//            .bind(to: rxSections)
//            .disposed(by: disposeBag)
//
        rxSections.subscribe(onNext: { [weak self] section in
            self?.pageData.sections = section
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
        let defaultSelectedList = pageData.sections?.first?.taskList
        let newTaskController = AddTaskViewController(defaultList: defaultSelectedList)
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
