//
//  AddGroupViewModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/18.
//

import PGFoundation
import RxSwift
import UIComponents
import Net

enum NewGroupUploadResult {
    case success(TaskList)
    case failed
    case error
}

struct AddGroupViewModelInput: ViewModelInput {
    let completeTapped = PublishSubject<(String, TasksGroupIconColor, String)>()
}

struct AddGroupViewModelOutput: ViewModelOutput {
    let uploadCompleted = PublishSubject<NewGroupUploadResult>()
}

class AddGroupViewModel: ViewModel {
    
    typealias Input = AddGroupViewModelInput
    typealias Output = AddGroupViewModelOutput
    
    var input: Input = AddGroupViewModelInput()
    
    private let disposeBag = DisposeBag()
    
    func transformToOutput() -> Output {
        let output = AddGroupViewModelOutput()
        
        input.completeTapped
            .flatMapLatest { [weak self] listName, color, imageName in
                self?.uploadNewTaskGroup(listName: listName, color: color, imageName: imageName) ?? Observable.never()
            }
            .bind(to: output.uploadCompleted)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func uploadNewTaskGroup(listName: String,
                            color: TasksGroupIconColor,
                            imageName: String) -> Observable<NewGroupUploadResult> {
        Observable<NewGroupUploadResult>.create { observer in
            let net = Net.build()
                .configPath(.addGroup)
                .configBody([
                    "list_name" : listName,
                    "list_color" : String(color.rawValue),
                    "image_name" : imageName
                ])
                .post { json in
                    if (json as? [String : Any])?["status"] as? Int == 200,
                       let dataJson = (json as? [String : Any])?["data"],
                       let data = try? JSONSerialization.data(withJSONObject: dataJson),
                       let newList = try? JSONDecoder().decode(TaskList.self, from: data) {
                        observer.onNext(.success(newList))
                    } else {
                        observer.onNext(.failed)
                    }
                } error: { err in
                    observer.onNext(.error)
                }
            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
