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
    // args: 图片，内容， taskId
    let sendNewPostAction = PublishSubject<([UIImage]?, String?, String?)>()
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
            .flatMapLatest { [weak self] images, content, taskId -> Observable<[String]?> in
                guard let images = images else {
                    return Observable<[String]?>.just([])
                }
                return self?.requestUpLoadImages(images: images) ?? Observable<[String]?>.never()
            }
            .withLatestFrom(input.sendNewPostAction) { ($0, $1.1, $1.2) }
            .flatMapLatest { [weak self] urls, content, taskId in
                self?.requestCreateBBSPost(content: content ?? "", taskId: taskId ?? "", imageUrls: urls ?? []) ?? Observable<CreatePostResult>.never()
            }
            .bind(to: output.sendNewPostCompleted)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func requestUpLoadImages(images: [UIImage]) -> Observable<[String]?> {
        Observable<[String]?>.create { observer in
            let net = Net
                .build()
                .configPath(.uploadBBSImage)
                .upload { formData in
                    for image in images {
                        if let jpegData = image.jpegData(compressionQuality: 0.5) {
                            print(jpegData)
                            formData.append(jpegData, withName: "images", fileName: UUID().uuidString + ".jpeg", mimeType: "image/jpeg")
                        }
                    }
                } completion: { json in
                    if (json as? [String : Any])?["status"] as? Int == 200,
                        let urls = (json as? [String : Any])?["data"] as? [String] {
                        observer.onNext(urls)
                    } else {
                        observer.onNext(nil)
                    }
                } error: { err in
                    observer.onNext(nil)
                }
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
    private func requestCreateBBSPost(content: String, taskId: String, imageUrls: [String]) -> Observable<CreatePostResult> {
        Observable<CreatePostResult>.create { observer in
            let net = Net
                .build()
                .configPath(.createPost)
                .configBody([
                    "content": content,
                    "taskId": taskId,
                    "images": imageUrls
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
