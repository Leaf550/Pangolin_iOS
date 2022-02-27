//
//  LoginViewModel.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import RxSwift

struct LoginViewModelInput: ViewModelInput {
    
}

struct LoginViewModelOutput: ViewModelOutput {
    
}

class LoginViewModel: ViewModel {
    typealias Input = LoginViewModelInput
    typealias Output = LoginViewModelOutput
    
    var input: LoginViewModelInput = LoginViewModelInput()
    
    func transformToOutput() -> LoginViewModelOutput {
        return LoginViewModelOutput()
    }
    
}
