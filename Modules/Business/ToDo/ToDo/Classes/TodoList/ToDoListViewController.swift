//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/3.
//

import UIKit
import UIComponents
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class ToDoListViewController: UIViewController {
    
    var titleColor: ToDoIconColor
    
    private var datasList = [
        ToDoListSection(header: "", items: [
            ToDoModel(isSelected: false, text: "1"),
            ToDoModel(isSelected: false, text: "2"),
            ToDoModel(isSelected: false, text: "3"),
            ToDoModel(isSelected: false, text: "4"),
            ToDoModel(isSelected: false, text: "5"),
            ToDoModel(isSelected: false, text: "6"),
            ToDoModel(isSelected: false, text: "7"),
            ToDoModel(isSelected: false, text: "8")
        ])
    ]
    
    lazy var sections = BehaviorSubject<[ToDoListSection]>(value: datasList)
    
    private let disposeBag = DisposeBag()
    
    private lazy var todoTable: TableView = {
        let table = TableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.sectionStyle = .squareCorner
        
        let datasource = RxTableViewSectionedAnimatedDataSource<ToDoListSection>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                guard let self = self else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseID, for: indexPath) as? ToDoTableViewCell
                cell?.tableView = tableView
                cell?.todoTextView.text = item.text
                cell?.checkBox.setSelect(item.isSelected)
                cell?.checkBox.checkBoxSelectCallBack = { selected in
                    if selected {
                        var index = 0
                        for i in 0 ..< self.datasList[indexPath.section].items.count {
                            if self.datasList[indexPath.section].items[i].text == cell?.todoTextView.text ?? "" {
                                index = i
                            }
                        }
                        var removed = self.datasList[indexPath.section].items.remove(at: index)
                        removed.isSelected = selected
                        self.datasList[indexPath.section].items.append(removed)
                        self.datasList[indexPath.section] = ToDoListSection(
                            original: self.datasList[indexPath.section],
                            items: self.datasList[indexPath.section].items
                        )
                        self.sections.onNext(self.datasList)
                    } else {

                    }
                }
                return cell ?? UITableViewCell()
            })
        
        sections.bind(to: table.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        table.rx.didScroll.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        return table
    }()
    
    init(titleColor: ToDoIconColor) {
        self.titleColor = titleColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTable.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseID)
        
        setUpSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : ToDoIconColorImpl.plainColor(with: titleColor)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(todoTable)
        todoTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
