//
//  AddTaskViewModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/20.
//

import PGFoundation
import RxSwift
import Net

struct AddTaskViewModelInput: ViewModelInput {
    let taskEditCompleted = PublishSubject<(TaskModel?, String, TaskEditMode)>()
}

struct AddTaskViewModelOutput: ViewModelOutput {
    let uploadResult = PublishSubject<(TaskModel?, String?)>()
}

class AddTaskViewModel: ViewModel {
    
    typealias Input = AddTaskViewModelInput
    typealias Output = AddTaskViewModelOutput
    
    var input: Input = AddTaskViewModelInput()
    
    private let disposeBag = DisposeBag()
    
    func transformToOutput() -> Output {
        let output = AddTaskViewModelOutput()
        
        input.taskEditCompleted
            .filter { (task, listId, _) in
                task?.title != nil && task?.title != "" && listId != ""
            }
            .flatMapLatest { [weak self] (task, listId, editMode) -> Observable<(TaskModel?, String?)> in
                if editMode == .editTask {
                    return self?.reqeustEditTask(task: task, listId: listId) ?? Observable<(TaskModel?, String?)>.never()
                } else if editMode == .newTask {
                    return self?.requestAddTask(task: task, listId: listId) ?? Observable<(TaskModel?, String?)>.never()
                }
                return Observable<(TaskModel?, String?)>.never()
            }
            .bind(to: output.uploadResult)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func reqeustEditTask(
        task: TaskModel?,
        listId: String
    ) -> Observable<(TaskModel?, String?)> {
        Observable<(TaskModel?, String?)>.create { observer in
            var requestBody = [String : String]()
            if task?.title == nil ||
                task?.title == "" ||
                task?.taskID == "" ||
                task?.taskID == "" {
                observer.onNext((nil, nil))
                return Disposables.create()
            }
            
            requestBody["taskId"] = task?.taskID ?? ""
            requestBody["title"] = task?.title ?? ""
            if let comment = task?.comment,
                comment != "" {
                requestBody["comment"] = comment
            }
            if let date = task?.date {
                requestBody["date"] = String(Int64(date))
            }
            if let _ = task?.date,
               let time = task?.time {
                requestBody["time"] = String(Int64(time))
            }
            requestBody["isImportant"] = (task?.isImportant ?? false) ? "1" : "0"
            requestBody["isCompleted"] = (task?.isCompleted ?? false) ? "1" : "0"
            requestBody["priority"] = String(task?.priority ?? 0)
            requestBody["listId"] = listId
            
            let net = Net
                .build()
                .configBody(requestBody)
                .configPath(.editTask)
                .post { json in
                    if (json as? [String : Any])?["status"] as? Int == 200 {
                        observer.onNext((task, listId))
                    } else {
                        observer.onNext((nil, nil))
                    }
                } error: { err in
                    observer.onNext((nil, nil))
                }

            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
    private func requestAddTask(
        task: TaskModel?,
        listId: String
    ) -> Observable<(TaskModel?, String?)> {
        Observable<(TaskModel?, String?)>.create { observer in
            var requestBody = [String : String]()
            requestBody["title"] = task?.title ?? ""
            if let comment = task?.comment {
                requestBody["comment"] = comment
            }
            if let date = task?.date {
                requestBody["date"] = String(Int64(date))
            }
            if let _ = task?.date,
               let time = task?.time {
                requestBody["time"] = String(Int64(time))
            }
            requestBody["isImportant"] = (task?.isImportant ?? false) ? "1" : "0"
            requestBody["listId"] = listId
            
            let net = Net.build()
                .configPath(.addTask)
                .configBody(requestBody)
                .post { json in
                    if (json as? [String : Any])?["status"] as? Int == 200 {
                        observer.onNext((task, listId))
                    } else {
                        observer.onNext((nil, nil))
                    }
                } error: { err in
                    observer.onNext((nil, nil))
                }

            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
