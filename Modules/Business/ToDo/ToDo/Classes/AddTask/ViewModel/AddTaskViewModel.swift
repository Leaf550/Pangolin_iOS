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
    let completeButtonTap = PublishSubject<(String, String?, Int64?, Int64?, Bool, String)>()
}

struct AddTaskViewModelOutput: ViewModelOutput {
    let uploadResult = PublishSubject<Bool>()
}

class AddTaskViewModel: ViewModel {
    
    typealias Input = AddTaskViewModelInput
    typealias Output = AddTaskViewModelOutput
    
    var input: Input = AddTaskViewModelInput()
    
    private let disposeBag = DisposeBag()
    
    func transformToOutput() -> Output {
        let output = AddTaskViewModelOutput()
        
        input.completeButtonTap
            .flatMapLatest { [weak self] (title, comment, date, time, isImportant, listId) in
                self?.requestAddTask(title: title, comment: comment, date: date, time: time, isImportant: isImportant, listId: listId) ?? Observable.never()
            }
            .bind(to: output.uploadResult)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func requestAddTask(
        title: String,
        comment: String?,
        date: Int64?,
        time: Int64?,
        isImportant: Bool,
        listId: String
    ) -> Observable<Bool> {
        Observable<Bool>.create { observer in
            var requestBody = [String : String]()
            requestBody["title"] = title
            if comment != nil {
                requestBody["comment"] = comment ?? ""
            }
            if date != nil {
                requestBody["date"] = String(date ?? 0)
            }
            if date != nil && time != nil {
                requestBody["time"] = String(time ?? 0)
            }
            requestBody["isImportant"] = isImportant ? "1" : "0"
            requestBody["listId"] = listId
            
            let net = Net.build()
                .configPath(.addTask)
                .configBody(requestBody)
                .post { json in
                    if (json as? [String : Any])?["status"] as? Int == 200 {
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                } error: { err in
                    observer.onNext(false)
                }

            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
