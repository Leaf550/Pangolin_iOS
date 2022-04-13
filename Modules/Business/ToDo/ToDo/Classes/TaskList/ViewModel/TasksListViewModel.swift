//
//  TasksListViewModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/16.
//

import PGFoundation
import RxSwift
import Net

struct TasksListViewModelInput: ViewModelInput {
    let updateTaskIsCompleted = PublishSubject<(TaskModel, Bool)>()
}

struct TasksListViewModelOutput: ViewModelOutput {
    let updateCompleted = PublishSubject<(String, Bool)>()
}

class TasksListViewModel: ViewModel {
    typealias Input = TasksListViewModelInput
    typealias Output = TasksListViewModelOutput
    
    var input: TasksListViewModelInput = TasksListViewModelInput()
    
    private let disposeBag = DisposeBag()
    
    func transformToOutput() -> TasksListViewModelOutput {
        let output = TasksListViewModelOutput()
        
        input.updateTaskIsCompleted
            .flatMapLatest { [weak self] (task, completed) -> Observable<(String, Bool)> in
                guard let taskId = task.taskID else { return Observable<(String, Bool)>.never() }
                return self?.updateTaskIsCompleted(taskId: taskId, isCompleted: completed) ?? Observable<(String, Bool)>.never()
            }
            .bind(to: output.updateCompleted)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func updateTaskIsCompleted(taskId: String, isCompleted: Bool) -> Observable<(String, Bool)> {
        Observable<(String, Bool)>.create { observer in
            let net = Net.build()
                .configPath(RequestPath.taskCompleted)
                .configBody([
                    "taskId" : taskId,
                    "completed" : isCompleted ? "1" : "0"
                ])
                .get { json in
                    if (json as? [String : Any])?["status"] as? Int == 200 {
                        observer.onNext((taskId, true))
                    } else {
                        observer.onNext((taskId, false))
                    }
                } error: { _ in
                    observer.onNext((taskId, false))
                }
            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
