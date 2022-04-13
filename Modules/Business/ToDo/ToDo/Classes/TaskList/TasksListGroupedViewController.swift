//
//  TasksListGroupedViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/4/13.
//

import UIKit
import PGFoundation
import UIComponents

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
                    completed.append(task)
                }
                j += 1
            }
            
            sections?[i].tasks?.append(contentsOf: completed)
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
                
                guard let self = self, var homeModel = homeModel else { return }
                
                var pageData: ListPageData?
                switch self.listType {
                    case .today:
                        pageData = homeModel.data?.today
                    case .important:
                        pageData = homeModel.data?.important
                    case .all:
                        pageData = homeModel.data?.all
                    case .completed:
                        pageData = homeModel.data?.completed
                    case .other(_):
                        return
                }
                
                if var sections = pageData?.sections {
                    for i in 0 ..< sections.count {
                        var taskIndex: Int?
                        for j in 0 ..< (sections[i].tasks?.count ?? 0) {
                            if sections[i].tasks?[j].taskID == task.taskID {
                                taskIndex = j
                            }
                        }
                        if let taskIndex = taskIndex,
                           var removed = sections[i].tasks?.remove(at: taskIndex) {
                            removed.isCompleted = selected
                            sections[i].tasks?.append(removed)
                            
                            pageData?.sections = sections
                            switch self.listType {
                                case .today:
                                    homeModel.data?.today = pageData
                                case .important:
                                    homeModel.data?.important = pageData
                                case .all:
                                    homeModel.data?.all = pageData
                                case .completed:
                                    homeModel.data?.completed = pageData
                                case .other(_):
                                    return
                            }
                            
                            TaskManager.shared.homeModel.onNext(homeModel)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }

}
