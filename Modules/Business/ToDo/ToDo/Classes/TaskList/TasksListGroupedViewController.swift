//
//  TasksListGroupedViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/4/13.
//

import UIKit
import PGFoundation
import UIComponents
import RxSwift

class TasksListGroupedViewController: TasksListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configTableDatas(with sections: [TasksListSection]?) -> [TasksListSection] {
        var sections = sections
        for i in 0 ..< (sections?.count ?? 0) {
            var completed = [TaskModel]()
            
            var j = 0
            while j < (sections?[i].tasks?.count ?? 0) {
                if let task = sections?[i].tasks?[j],
                    task.isCompleted ?? false {
                    sections?[i].tasks?.remove(at: j)
                    j -= 1
                    completed.append(task)
                }
                j += 1
            }
            
            sections?[i].tasks?.append(contentsOf: completed.sorted(by: { first, second in
                (first.createTime ?? 0) < (second.createTime ?? 0)
            }))
        }
        
        return sections ?? []
    }
    
    var requestCompleteDisposable: Disposable?
    
    override func didSelectCheckBox(with task: TaskModel, selected: Bool, sender: CheckBox, cell: TaskTableViewCell?) {
        self.completeTaskDisposeBag = DisposeBag()
        
        cell?.contentView.alpha = 0.5
        cell?.contentView.isUserInteractionEnabled = false
        
        requestSetTaskIsCompleted.onNext((task, selected))
        
        requestSetTaskIsCompletedFinished
            .withLatestFrom(TaskManager.shared.homeModel) { ($0.0, $0.1, $1) }
            .subscribe(onNext: { [weak self] (taskId, succeeded, homeModel) in
                guard let currentId = task.taskID, currentId == taskId else { return }

                cell?.contentView.alpha = 1
                cell?.contentView.isUserInteractionEnabled = true

                if !succeeded {
                    Toast.show(text: "请求失败", image: nil)
                    sender.isSelected = !selected
                    return
                }

                guard var homeModel = homeModel else { return }

                for i in 0 ..< (homeModel.data?.otherList?.count ?? 0) {
                    if (homeModel.data?.otherList?[i].sections?.count ?? 0) <= 0 {
                        continue
                    }
                    var has: Bool = false
                    if var listPage = homeModel.data?.otherList?[i] {
                        for j in 0 ..< (listPage.sections?.first?.tasks?.count ?? 0) {
                            let taskInModel = listPage.sections?.first?.tasks?[j]
                            if taskInModel?.taskID == currentId {
                                listPage.sections?[0].tasks?[j].isCompleted = selected
                                homeModel.data?.otherList?[i] = listPage
                                has = true
                                break
                            }
                        }
                    }
                    if has {
                        break
                    }
                }

                TaskManager.shared.homeModel.onNext(homeModel)
                
                self?.requestCompleteDisposable?.dispose()
            }).disposed(by: completeTaskDisposeBag)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].taskList?.listName ?? ""
    }

}
