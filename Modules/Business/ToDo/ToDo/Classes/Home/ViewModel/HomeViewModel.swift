//
//  HomeViewModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/15.
//

import PGFoundation
import Net
import RxRelay
import RxSwift
import Foundation

struct HomeViewModelInput: ViewModelInput {
    let onHomeRefresh = PublishRelay<Void>()
}

struct HomeViewModelOutput: ViewModelOutput {
    let homeModel = PublishRelay<HomeModel?>()
}

class HomeViewModel: ViewModel {
    
    typealias Input = HomeViewModelInput
    typealias Output = HomeViewModelOutput
    
    var input: Input = HomeViewModelInput()
    
    private var disposeBag = DisposeBag()
    
    func transformToOutput() -> HomeViewModelOutput {
        let output = HomeViewModelOutput()
        
        input.onHomeRefresh
            .flatMapLatest { [weak self] _ in
                self?.requestHomeModel() ?? Observable.never()
            }
            .bind(to: output.homeModel)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func requestHomeModel() -> Observable<HomeModel?> {
        Observable<HomeModel?>.create { observer in
            let net = Net.build()
                .configPath(.home)
                .get { json in
                    guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                        observer.onNext(nil)
                        return
                    }
                    guard let model = try? JSONDecoder().decode(HomeModel.self, from: data) else {
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
