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
import Provider

struct HomeViewModelInput: ViewModelInput {
    let onHomeRefresh = PublishSubject<Void>()
}

struct HomeViewModelOutput: ViewModelOutput {
    let homeModel = PublishRelay<HomeModel?>()
}

class HomeViewModel: ViewModel {
    
    typealias Input = HomeViewModelInput
    typealias Output = HomeViewModelOutput
    
    var input: Input = HomeViewModelInput()
    
    private let persistenceService = PGProviderManager.shared.provider { PersistenceProvider.self }
    
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
                .get { [weak self] json in
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
                        if let self = self {
                            _ = self.persistenceService?.saveHomeModel(model)
                        }
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
