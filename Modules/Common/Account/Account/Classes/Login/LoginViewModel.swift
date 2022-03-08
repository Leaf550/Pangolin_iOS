//
//  LoginViewModel.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import RxSwift
import RxRelay
import Net

struct LoginViewModelInput: ViewModelInput {
    var username = PublishRelay<String>()
    var password = PublishRelay<String>()
    var loginTap = PublishRelay<Void>()
}

struct LoginViewModelOutput: ViewModelOutput {
    var loginButtonEnabled = BehaviorRelay<Bool>(value: false)
    var loginResult = PublishSubject<LoginResponse?>()
}

class LoginViewModel: ViewModel {
    typealias Input = LoginViewModelInput
    typealias Output = LoginViewModelOutput
    
    var input: LoginViewModelInput = LoginViewModelInput()
    
    private var disposeBage = DisposeBag()
    
    func transformToOutput() -> LoginViewModelOutput {
        let output = LoginViewModelOutput()
        
        let usernameInputed = input.username.map { $0.count != 0 }
        let passwordInputed = input.password.map { $0.count != 0 }
        
        Observable.combineLatest(usernameInputed, passwordInputed) { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
            .drive(output.loginButtonEnabled)
            .disposed(by: disposeBage)
        
        input.loginTap
            .withLatestFrom(Observable.combineLatest(input.username, input.password))
            .flatMapLatest { [weak self] in
                self?.requestLogin(username: $0, password: $1) ?? Observable<LoginResponse?>.never()
            }
            .bind(to: output.loginResult)
            .disposed(by: disposeBage)
        
        return output
    }
    
    private func requestLogin(username: String, password: String) -> Observable<LoginResponse?> {
        Observable<LoginResponse?>.create { observer in
            let requestBody: [String : String] = [
                "username": username,
                "password": password
            ]
            let net = Net.build()
                .configPath(.signIn)
                .configBody(requestBody)
                .post { json in
                    guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                        observer.onNext(nil)
                        return
                    }
                    guard let response = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                        observer.onNext(nil)
                        return
                    }
                    observer.onNext(response)
                } error: { error in
                    observer.onNext(nil)
                }
            
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
