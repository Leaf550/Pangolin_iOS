//
//  NewPostViewModel.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/19.
//

import PGFoundation
import RxSwift
import Net

enum CreatePostResult {
    case succeeded
    case duplicateShare
    case error
}

struct NewPostViewModelInput: ViewModelInput {
    // args: 内容， taskId
    let sendNewPostAction = PublishSubject<(String?, String?)>()
}

struct NewPostViewModelOutput: ViewModelOutput {
    // args: 上传是否成功
    let sendNewPostCompleted = PublishSubject<CreatePostResult>()
}

class NewPostViewModel: ViewModel {
    
    typealias Input = NewPostViewModelInput
    typealias Output = NewPostViewModelOutput
    
    var input: Input = NewPostViewModelInput()
    
    private var disposeBag = DisposeBag()
    
    func transformToOutput() -> NewPostViewModelOutput {
        let output = NewPostViewModelOutput()
        
        input.sendNewPostAction
            .flatMapLatest { [weak self] content, taskId -> Observable<CreatePostResult> in
                guard let content = content, let taskId = taskId else {
                    return Observable<CreatePostResult>.never()
                }
                return self?.requestCreateBBSPost(content: content, taskId: taskId) ?? Observable<CreatePostResult>.never()
            }
            .bind(to: output.sendNewPostCompleted)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func requestCreateBBSPost(content: String, taskId: String) -> Observable<CreatePostResult> {
        Observable<CreatePostResult>.create { observer in
            let net = Net
                .build()
                .configPath(.createPost)
                .configBody([
                    "content": content,
                    "taskId": taskId
                ])
                .post { json in
                    if (json as? [String : Any])?["status"] as? Int == 200 {
                        observer.onNext(.succeeded)
                    } else if (json as? [String : Any])?["status"] as? Int == 606 {
                        observer.onNext(.duplicateShare)
                    } else {
                        observer.onNext(.error)
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
