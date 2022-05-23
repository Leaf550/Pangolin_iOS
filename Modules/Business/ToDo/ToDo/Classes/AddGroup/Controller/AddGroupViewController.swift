//
//  AddGroupViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import PGFoundation
import UIComponents
import SnapKit
import RxSwift

class AddGroupViewController: UIViewController, ViewController, UITableViewDataSource, UITableViewDelegate {
    
    typealias VM = AddGroupViewModel
 
    var viewModel: VM = AddGroupViewModel()
    
    var disposeBag = DisposeBag()
    
    private var listName: String?
    private var color: TasksGroupIconColor = .red
    private var imageName: String = "0"
    
    private lazy var tableView: TableView = {
        let table = TableView()
        
        table.register(GroupTitleTableViewCell.self, forCellReuseIdentifier: GroupTitleTableViewCell.reuseID)
        table.register(GroupColorTableViewCell.self, forCellReuseIdentifier: GroupColorTableViewCell.reuseID)
        table.register(GroupIconTableViewCell.self, forCellReuseIdentifier: GroupIconTableViewCell.reuseID)
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.rx.setDelegate(self).disposed(by: disposeBag)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        setUpSubViews()
        bindViewModel()
    }
    
    func bindViewModel() {
        navigationItem.rightBarButtonItem?.rx.tap
            .asObservable()
            .map { [weak self] in
                (self?.listName , self?.color, self?.imageName)
            }
            .filter { (listName, color, imageName) in
                let a = listName != nil && listName != ""
                let b = color != nil
                let c = imageName != nil && imageName != ""
                if !(a && b && c) {
                    Toast.show(text: "请将内容填写完整哦～", image: nil)
                    return false
                }
                return true
            }
            .map {
                ($0 ?? "", $1 ?? .blue, $2 ?? "")
            }
            .bind(to: viewModel.input.completeTapped)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.uploadCompleted
            .subscribe(onNext: { [weak self] result in
                switch result {
                    case .success(let newList):
                        TaskManager.shared.addTaskList(taskList: newList)
                        self?.dismiss(animated: true, completion: nil)
                    case .failed:
                        Toast.show(text: "上传失败", image: nil)
                    case .error:
                        break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configNavigationBar() {
        title = "新建列表"
        
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
        leftButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "完成", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setUpSubViews() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension AddGroupViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GroupConfigBaseTableViewCell?
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupTitleTableViewCell.reuseID, for: indexPath) as? GroupTitleTableViewCell
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupColorTableViewCell.reuseID, for: indexPath) as? GroupColorTableViewCell
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: GroupIconTableViewCell.reuseID, for: indexPath) as? GroupIconTableViewCell
        }
        
        cell?.didSelectColor = { [weak self] color in
            let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupTitleTableViewCell
            titleCell?.groupIcon?.color = color
            titleCell?.textFieldTextColor = color
            self?.color = color
        }
        
        cell?.didSelectImage = { [weak self] imageName in
            let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupTitleTableViewCell
            titleCell?.groupIcon?.image = UIImage(named: imageName + "large") ?? UIImage()
            self?.imageName = imageName
        }
        
        cell?.groupTitleTextTield?.rx
            .text
            .orEmpty
            .subscribe(onNext: { [weak self] title in
                self?.listName = title
            })
            .disposed(by: disposeBag)
            
        
        return cell ?? UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate
extension AddGroupViewController {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
}
