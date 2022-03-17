//
//  HomeViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import PGFoundation
import UIComponents
import SnapKit
import Util
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, ViewController {
    
    typealias VM = HomeViewModel
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    private var homeModel = BehaviorRelay<HomeModel?>(value: nil)
    
    var disposeBag = DisposeBag()
    
    private lazy var listsTableView: TableView = {
        let table = TableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = 54
        
        homeModel
            .map { $0?.data?.taskLists ?? [] }
            .bind(to: table.rx.items(cellIdentifier: TasksGroupTableViewCell.reuseID, cellType: TasksGroupTableViewCell.self)) { [weak self] row, data, cell in
                guard let self = self else { return }
                cell.titleLabel.text = data.listName
                cell.numberLabel.text = String(data.taskCount ?? 0)
                cell.iconColor = TasksGroupIconColor(rawValue: data.listColor ?? 0) ?? .blue
                let numberOfRows = table.numberOfRows(inSection: 0)
                cell.hasSeparateLine = (row != numberOfRows - 1)
            }
            .disposed(by: disposeBag)
        
        table.rx.itemSelected
            .withLatestFrom(homeModel) {
                ($0, $1)
            }
            .bind { [weak self] indexPath, homeModel in
                let todoListController = TasksListViewController(
                    titleColor: TasksGroupIconColor(rawValue: homeModel?.data?.taskLists?[indexPath.row].listColor ?? 0) ?? .blue,
                    title: homeModel?.data?.taskLists?[indexPath.row].listName ?? "",
                    listType: .other(homeModel?.data?.taskLists?[indexPath.row].listID ?? "")
                )
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
    
    private lazy var topToDoLists: TopTasksListView = {
        let view = TopTasksListView()
        
        view.todayTapped = { [weak self] in
            let todoListController = TasksListViewController(
                titleColor: .blue,
                title: "今天",
                listType: .today
            )
            todoListController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(todoListController, animated: true)
        }
        
        view.importantTapped = { [weak self] in
            let todoListController = TasksListViewController(
                titleColor: .orange,
                title: "重要",
                listType: .important
            )
            todoListController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(todoListController, animated: true)
        }
        
        view.allTapped = { [weak self] in
            let todoListController = TasksListViewController(
                titleColor: .gray,
                title: "全部",
                listType: .all
            )
            todoListController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(todoListController, animated: true)
        }
        
        view.completedTapped = { [weak self] in
            let todoListController = TasksListViewController(
                titleColor: .green,
                title: "已完成",
                listType: .completed
            )
            todoListController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(todoListController, animated: true)
        }
        
        return view
    }()
    
    private lazy var tableHeaderView: UIView = {
        let header = UIView()
        
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
        
        view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "列表"
        self.navigationItem.titleView = UIView()
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightItem
        
        listsTableView.register(TasksGroupTableViewCell.self, forCellReuseIdentifier: TasksGroupTableViewCell.reuseID)
        
        setUpSubView()
        bindViewModel()
    }
    
    func bindViewModel() {
        rx.methodInvoked(#selector(viewDidAppear(_:)))
            .map { _ in Void() }
            .bind(to: viewModel.input.onHomeRefresh)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.homeModel
            .bind(to: homeModel)
            .disposed(by: disposeBag)
        
        output.homeModel
            .subscribe(onNext: { [weak self] model in
                self?.topToDoLists.todayList.setNumber(number: model?.data?.today ?? 0)
                self?.topToDoLists.flagList.setNumber(number: model?.data?.important ?? 0)
                self?.topToDoLists.allList.setNumber(number: model?.data?.all ?? 0)
                self?.topToDoLists.finishedList.setNumber(number: model?.data?.completed ?? 0)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpSubView() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(listsTableView)
        listsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Screen.statusBarHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc
    private func addButtonTapped() {
        let addGroupController = AddGroupViewController()
        let navController = UINavigationController(rootViewController: addGroupController)
        present(navController, animated: true, completion: nil)
    }

}
