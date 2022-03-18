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
            .map { $0?.data?.otherList ?? [] }
            .bind(to: table.rx.items(cellIdentifier: TasksGroupTableViewCell.reuseID, cellType: TasksGroupTableViewCell.self)) { [weak self] row, data, cell in
                guard let self = self else { return }
                let section = data.sections?.first
                cell.titleLabel.text = section?.taskList?.listName ?? ""
                cell.numberLabel.text = String(section?.tasks?.count ?? 0)
                cell.iconColor = TasksGroupIconColor(rawValue: section?.taskList?.listColor ?? 0) ?? .blue
                let numberOfRows = table.numberOfRows(inSection: 0)
                cell.hasSeparateLine = (row != numberOfRows - 1)
            }
            .disposed(by: disposeBag)
        
        table.rx.itemSelected
            .withLatestFrom(homeModel) {
                ($0, $1)
            }
            .bind { [weak self] indexPath, homeModel in
                let taskList = homeModel?.data?.otherList?[indexPath.row].sections?.first?.taskList
                let todoListController = TasksListViewController(
                    titleColor: TasksGroupIconColor(rawValue: taskList?.listColor ?? 0) ?? .blue,
                    title: taskList?.listName ?? "",
                    pageData: homeModel?.data?.otherList?[indexPath.row] ?? ListPageData()
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
        
        view.todayTapped
            .withLatestFrom(homeModel) { ($0, $1) }
            .bind { [weak self] _, homeModel in
                guard let todayData = homeModel?.data?.today else { return }
                let todoListController = TasksListViewController(
                    titleColor: .blue,
                    title: "今天",
                    pageData: todayData
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.importantTapped
            .withLatestFrom(homeModel) { ($0, $1) }
            .bind { [weak self] _, homeModel in
                guard let importantData = homeModel?.data?.important else { return }
                let todoListController = TasksListViewController(
                    titleColor: .orange,
                    title: "重要",
                    pageData: importantData
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.allTapped
            .withLatestFrom(homeModel) { ($0, $1) }
            .bind { [weak self] _, homeModel in
                guard let allData = homeModel?.data?.all else { return }
                let todoListController = TasksListViewController(
                    titleColor: .gray,
                    title: "全部",
                    pageData: allData
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.completedTapped
            .withLatestFrom(homeModel) { ($0, $1) }
            .bind { [weak self] _, homeModel in
                guard let completedData = homeModel?.data?.completed else { return }
                let todoListController = TasksListViewController(
                    titleColor: .green,
                    title: "已完成",
                    pageData: completedData
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
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
                self?.topToDoLists.todayList.setNumber(number: model?.data?.todayCount ?? 0)
                self?.topToDoLists.importantList.setNumber(number: model?.data?.importantCount ?? 0)
                self?.topToDoLists.allList.setNumber(number: model?.data?.allCount ?? 0)
                self?.topToDoLists.completedList.setNumber(number: model?.data?.completedCount ?? 0)
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
