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
import Net

enum ListType {
    case today
    case important
    case all
    case completed
    case other(Int)
}

class TasksListViewController: UIViewController, ViewController, UITableViewDelegate {
    
    typealias VM = TasksListViewModel
    var viewModel = TasksListViewModel()
    var disposeBag = DisposeBag()
    
    var titleColor: TasksGroupIconColor
    var listId: String?
    var listType: ListType
    var listIndex: Int?
    
    lazy var rxSections = ReplaySubject<[TasksListSection]>.create(bufferSize: 1)
    var sections: [TasksListSection] = []
    
    var requestSetTaskIsCompleted = PublishSubject<(TaskModel, Bool)>()
    var requestSetTaskIsCompletedCompleted = PublishSubject<(String, Bool)>()
    
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
                    if !Net.isReachableToServer() {
                        Toast.show(text: "暂无网络连接", image: nil)
                        return
                    }
                    self.didSelectCheckBox(with: item, selected: selected, cell: cell)
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
         listType: ListType) {
        self.titleColor = titleColor
        self.listType = listType
        super.init(nibName: nil, bundle: nil)
        self.title = title
        
        TaskManager.shared.homeModel
            .map { [weak self] homeModel -> [TasksListSection] in
                var sections: [TasksListSection]?
                switch listType {
                    case .today:
                        sections = homeModel?.data?.today?.sections
                    case .important:
                        sections = homeModel?.data?.important?.sections
                    case .all:
                        sections = homeModel?.data?.all?.sections
                    case .completed:
                        sections = homeModel?.data?.completed?.sections
                    case .other(let listIndex):
                        self?.listIndex = listIndex
                        sections = homeModel?.data?.otherList?[listIndex].sections
                }
                
                return self?.configTableDatas(with: sections) ?? []
            }
            .subscribe(onNext: { [weak self] sections in
                self?.sections = sections
                self?.rxSections.onNext(sections)
            })
            .disposed(by: disposeBag)
    }
    
    func configTableDatas(with sections: [TasksListSection]?) -> [TasksListSection] {
        []
    }
    
    func didSelectCheckBox(with task: TaskModel, selected: Bool, cell: TaskTableViewCell?) {
        
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
        requestSetTaskIsCompleted
            .bind(to: viewModel.input.updateTaskIsCompleted)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.updateCompleted
            .bind(to: requestSetTaskIsCompletedCompleted)
            .disposed(by: disposeBag)
        
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
        let defaultSelectedList = sections.first?.taskList
        let newTaskController = AddTaskViewController(defaultList: defaultSelectedList)
        let navController = UINavigationController(rootViewController: newTaskController)
        present(navController, animated: true, completion: nil)
    }
    
}
