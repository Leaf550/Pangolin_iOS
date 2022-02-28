//
//  SignUpViewModel.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

import PGFoundation
import Net
import RxSwift
import RxRelay

struct SignUpViewModelInput: ViewModelInput {
    let username = PublishRelay<String>()
    let password = PublishRelay<String>()
    let repeatedPassword = PublishRelay<String>()
    let signUpButtonTap = PublishRelay<Void>()
}

struct SignUpViewModelOutput: ViewModelOutput {
    let usernameValied = BehaviorRelay<Bool>(value: true)
    let passwordValied = BehaviorRelay<Bool>(value: true)
    let repeatePasswordValied = BehaviorRelay<Bool>(value: true)
    let signUpButtonEnabled = BehaviorRelay<Bool>(value: false)
    let signUpResult = PublishSubject<SignUpResponse?>()
}

class SignUpViewModel: ViewModel {
    
    typealias Input = SignUpViewModelInput
    typealias Output = SignUpViewModelOutput
    
    var input: SignUpViewModelInput = SignUpViewModelInput()
    
    private var disposeBag = DisposeBag()
    
    func transformToOutput() -> SignUpViewModelOutput {
        let output = SignUpViewModelOutput()
        
        input.username
            .map { $0.count == 0 || $0.count > 5 && $0.count < 13 }
            .bind(to: output.usernameValied)
            .disposed(by: disposeBag)
        
        input.password
            .map { $0.count == 0 || $0.count > 5 && $0.count < 17 }
            .bind(to: output.passwordValied)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.password, input.repeatedPassword)
            .map { $1.count == 0 || $0 == $1 }
            .bind(to: output.repeatePasswordValied)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.usernameValied,
            output.passwordValied,
            output.repeatePasswordValied,
            input.username,
            input.password,
            input.repeatedPassword)
            .map { $0 && $1 && $2 && $3.count != 0 && $4.count != 0 && $5.count != 0 }
            .bind(to: output.signUpButtonEnabled)
            .disposed(by: disposeBag)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password)
        input.signUpButtonTap
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest { [weak self] username, password in
                self?.requestSignUp(username: username, password: password) ?? Observable.never()
            }
            .bind(to: output.signUpResult)
            .disposed(by: disposeBag)
                
        return output
    }
    
    private func requestSignUp(username: String, password: String) -> Observable<SignUpResponse?> {
        Observable<SignUpResponse?>.create { observer in
            let requestBody = [
                "username" : username,
                "password" : password
            ]
            let net = Net.build()
                .configPath(.signUp)
                .configBody(requestBody)
                .post { json in
                    guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                        observer.onNext(nil)
                        return
                    }
                    guard let response = try? JSONDecoder().decode(SignUpResponse.self, from: data) else {
                        observer.onNext(nil)
                        return
                    }
                    observer.onNext(response)
                } error: { err in
                    observer.onNext(nil)
                }
            return Disposables.create {
                net.cancel()
            }
        }
    }
    
}
