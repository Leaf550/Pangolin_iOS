//
//  BBSViewModel.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/14.
//

import PGFoundation
import RxSwift
import Net

struct BBSViewModelInput: ViewModelInput {
    let bbsHomeRefresh = PublishSubject<Void>()
    let bbsPostPraise = PublishSubject<String>()
}

struct BBSViewModelOutput: ViewModelOutput {
    let bbsHomeRefreshCompleted = PublishSubject<BBSHomeModel?>()
}

class BBSViewModel: ViewModel {
    
    var input = BBSViewModelInput()
    
    typealias Input = BBSViewModelInput
    typealias Output = BBSViewModelOutput
    
    private let disposeBag = DisposeBag()
    
    func transformToOutput() -> BBSViewModelOutput {
        let output = BBSViewModelOutput()
        
        input.bbsHomeRefresh
            .flatMapLatest { [weak self] _ in
                self?.requestAllBBSPosts() ?? Observable<BBSHomeModel?>.never()
            }
            .bind(to: output.bbsHomeRefreshCompleted)
            .disposed(by: disposeBag)
        
        input.bbsPostPraise
            .subscribe(onNext: { [weak self] postId in
                self?.reqeustPraise(postId: postId)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func requestAllBBSPosts() -> Observable<BBSHomeModel?> {
        Observable<BBSHomeModel?>.create { observer in
            
            let net = Net.build()
                .configPath(.bbsHome)
                .get { json in
                    guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                        observer.onNext(nil)
                        return
                    }
                    guard let model = try? JSONDecoder().decode(BBSHomeModel.self, from: data) else {
                        observer.onNext(nil)
                        return
                    }
                    observer.onNext(model)
                } error: { err in
                    observer.onNext(nil)
                }
            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
    private func reqeustPraise(postId: String) {
        _ = Net.build()
            .configPath(.praisePost)
            .configBody([
                "postId" : postId
            ])
            .get { _ in } error: { _ in }
    }
    
}
