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
import Provider

class HomeViewController: UIViewController, ViewController {
    
    typealias VM = HomeViewModel
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    var disposeBag = DisposeBag()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var listsTableView: TableView = {
        let table = TableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = 54
        
        table.addSubview(refreshControl)
        
        TaskManager.shared.homeModel
            .map { $0?.data?.otherList ?? [] }
            .bind(to: table.rx.items(cellIdentifier: TasksGroupTableViewCell.reuseID, cellType: TasksGroupTableViewCell.self)) { [weak self] row, data, cell in
                guard let self = self else { return }
                let section = data.sections?.first
                cell.titleLabel.text = section?.taskList?.listName ?? ""
                let unCompletedCount = section?.tasks?.reduce(0, { partialResult, task in
                    partialResult + ((task.isCompleted ?? false) ? 0 : 1 )
                })
                cell.numberLabel.text = String(unCompletedCount ?? 0)
                let imageName = section?.taskList?.imageName ?? "0"
                cell.iconImage = UIImage(named: "\(imageName)medium") ?? UIImage()
                cell.iconColor = TasksGroupIconColor(rawValue: section?.taskList?.listColor ?? 0) ?? .blue
                let numberOfRows = table.numberOfRows(inSection: 0)
                cell.hasSeparateLine = (row != numberOfRows - 1)
            }
            .disposed(by: disposeBag)
        
        table.rx.itemSelected
            .withLatestFrom(TaskManager.shared.homeModel) {
                ($0, $1)
            }
            .bind { [weak self] indexPath, homeModel in
                guard let pageData = homeModel?.data?.otherList?[indexPath.row] else { return }
                let taskList = pageData.sections?.first?.taskList
                let todoListController = TasksListPlainViewController(
                    titleColor: TasksGroupIconColor(rawValue: taskList?.listColor ?? 0) ?? .blue,
                    title: taskList?.listName ?? "",
                    listType: .other(indexPath.row)
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
            .bind { [weak self] _ in
                let todoListController = TasksListGroupedViewController(
                    titleColor: .blue,
                    title: "今天",
                    listType: .today
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.importantTapped
            .bind { [weak self] _ in
                let todoListController = TasksListGroupedViewController(
                    titleColor: .orange,
                    title: "重要",
                    listType: .important
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.allTapped
            .bind { [weak self] _ in
                let todoListController = TasksListGroupedViewController(
                    titleColor: .gray,
                    title: "全部",
                    listType: .all
                )
                todoListController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(todoListController, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.completedTapped
            .bind { [weak self] _ in
                let todoListController = TasksListGroupedViewController(
                    titleColor: .green,
                    title: "已完成",
                    listType: .completed
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
        beginRefresh()
    }
    
    func bindViewModel() {
        let output = viewModel.transformToOutput()
        
        output.homeModel
            .filter({ [weak self] model in
                print("test --- ")
                if model == nil {
                    Toast.show(text: "网络错误，仅可浏览", image: nil)
                }
                self?.refreshControl.endRefreshing()
                return model != nil
            })
            .bind(to: TaskManager.shared.homeModel)
            .disposed(by: disposeBag)
        
        TaskManager.shared.todayPageData
            .subscribe(onNext: { [weak self] allPageData in
                let count = allPageData?.sections?.reduce(0, { partialResult, section in
                    return partialResult + (section.tasks?.count ?? 0)
                }) ?? 0
                self?.topToDoLists.todayList.setNumber(number: count)
            })
            .disposed(by: disposeBag)
        
        TaskManager.shared.importantPageData
            .subscribe(onNext: { [weak self] allPageData in
                let count = allPageData?.sections?.reduce(0, { partialResult, section in
                    return partialResult + (section.tasks?.count ?? 0)
                }) ?? 0
                self?.topToDoLists.importantList.setNumber(number: count)
            })
            .disposed(by: disposeBag)
        
        TaskManager.shared.allPageData
            .subscribe(onNext: { [weak self] allPageData in
                let count = allPageData?.sections?.reduce(0, { partialResult, section in
                    return partialResult + (section.tasks?.count ?? 0)
                }) ?? 0
                self?.topToDoLists.allList.setNumber(number: count)
            })
            .disposed(by: disposeBag)
        
        TaskManager.shared.completedPageData
            .subscribe(onNext: { [weak self] allPageData in
                let count = allPageData?.sections?.reduce(0, { partialResult, section in
                    return partialResult + (section.tasks?.count ?? 0)
                }) ?? 0
                self?.topToDoLists.completedList.setNumber(number: count)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func beginRefresh() {
        viewModel.input.onHomeRefresh.onNext(Void())
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
