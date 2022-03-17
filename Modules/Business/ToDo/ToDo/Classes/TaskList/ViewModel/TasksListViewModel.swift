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
    let viewDidLoadWithListId = PublishSubject<String>()
}

struct TasksListViewModelOutput: ViewModelOutput {
    let tasksListModel = PublishSubject<TasksListModel?>()
}

class TasksListViewModel: ViewModel {
    typealias Input = TasksListViewModelInput
    typealias Output = TasksListViewModelOutput
    
    var input: TasksListViewModelInput = TasksListViewModelInput()
    
    private let disposeBag = DisposeBag()
    
    func transformToOutput() -> TasksListViewModelOutput {
        let output = TasksListViewModelOutput()
        
        input.viewDidLoadWithListId
            .flatMapLatest { [weak self] listId in
                self?.requestTasksList(withListId: listId) ?? Observable.never()
            }
            .bind(to: output.tasksListModel)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func requestTasksList(withListId listId: String) -> Observable<TasksListModel?> {
        Observable<TasksListModel?>.create { observer in
            let net = Net.build()
                .configHost(.mock)
                .configPath(.tasksList)
                .configBody([
                    "listId" : listId
                ])
                .get { json in
                    guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                        observer.onNext(nil)
                        return
                    }
                    guard let model = try? JSONDecoder().decode(TasksListModel.self, from: data) else {
                        observer.onNext(nil)
                        return
                    }
                    if model.status != 200 {
                        observer.onNext(nil)
                    } else {
                        observer.onNext(model)
                    }
                } error: { err in
                    observer.onNext(nil)
                }
            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
