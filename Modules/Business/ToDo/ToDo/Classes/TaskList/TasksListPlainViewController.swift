//
//  TasksListPlainViewÇontroller.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/4/13.
//

import UIComponents
import PGFoundation

class TasksListPlainViewController: TasksListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configTableDatas(with sections: [TasksListSection]?) -> [TasksListSection] {
        var sections = sections
        for i in 0 ..< (sections?.count ?? 0) {
            let new = sections?[i].tasks?.filter {
                ($0.isCompleted ?? false) == false
            }
            sections?[i].tasks = new
        }
        return sections ?? []
    }
    
    override func didSelectCheckBox(with task: TaskModel, selected: Bool, cell: TaskTableViewCell?) {
        cell?.contentView.alpha = 0.5
        cell?.contentView.isUserInteractionEnabled = false
        
        requestSetTaskIsCompleted.onNext((task, selected))
        
        requestSetTaskIsCompletedCompleted
            .withLatestFrom(TaskManager.shared.homeModel) { ($0.0, $0.1, $1) }
            .subscribe(onNext: { [weak self] (taskId, succeeded, homeModel) in
                guard let currentId = task.taskID, currentId == taskId else { return }
                
                cell?.contentView.alpha = 1
                cell?.contentView.isUserInteractionEnabled = true
                
                if !succeeded {
                    Toast.show(text: "请求失败", image: nil)
                    return
                }
                if let listIndex = self?.listIndex,
                   var homeModel = homeModel,
                   var sections = homeModel.data?.otherList?[listIndex].sections {
                    if sections.count > 0 {
                        var taskIndex: Int?
                        for i in 0 ..< (sections[0].tasks?.count ?? 0) {
                            if let current = sections[0].tasks?[i],
                               current.taskID == task.taskID {
                                taskIndex = i
                            }
                        }
                        if let index = taskIndex {
                            sections[0].tasks?[index].isCompleted = selected
                            homeModel.data?.otherList?[listIndex].sections = sections
                            TaskManager.shared.homeModel.onNext(homeModel)
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }

}
