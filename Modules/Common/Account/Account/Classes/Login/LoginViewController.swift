//
//  LoginViewController.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import PGFoundation
import UIComponents
import SnapKit
import Util
import Net
import RxCocoa

class LoginViewController: ViewController<LoginViewModel>, UITextFieldDelegate {
    
    var loginCompletion: (Bool) -> Void = { _ in }
    
    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "登录"
        label.textColor = .label
        label.font = .textFont(for: .largeTitle, weight: .regular)
        
        return label
    }()
    
    private lazy var usernameTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "请填写用户名"
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "请填写密码"
        textField.isSecureTextEntry = true
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("还没有账号？", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .textFont(for: .caption1, weight: .regular)
        button.rx.tap.subscribe(onNext: { [weak self] _ in
            let signUpConroller = SignUpViewController(viewModel: SignUpViewModel())
            signUpConroller.signUpCompletion = { completion in
                if completion {
                    self?.dismiss(animated: true) {
                        self?.loginCompletion(true)
                    }
                }
            }
            self?.present(signUpConroller, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .disabled)
        button.titleLabel?.font = .textFont(for: .title3, weight: .regular)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("一会儿再来...", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .textFont(for: .caption1, weight: .regular)
        
        button.rx.tap.subscribe { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.loginCompletion(false)
            }
        }.disposed(by: disposeBag)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        setUpSubviews()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
        
        for index in string.indices {
            if !charset.contains(string[index]) {
                return false
            }
        }
        
        return true
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.input.loginTap)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.loginButtonEnabled.asDriver()
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.loginResult
            .subscribe(onNext: { [weak self] response in
                guard let response = response else {
                    Toast.show(text: "请求失败")
                    return
                }
                
                if response.status == LoginStatusCode.pwdErr.rawValue {
                    Toast.show(text: "账号或密码错误")
                    return
                }
                
                guard let token = response.data?.tokenString else {
                    Toast.show(text: "请求失败")
                    return
                }
                
                UserManager.shared.login(withToken: token) { user, message in
                    guard user != nil else {
                        // token无法解析
                        Toast.show(text: message ?? "")
                        return
                    }
                    
                    self?.dismiss(animated: true) {
                        self?.loginCompletion(true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpSubviews() {
        view.addSubview(loginTitleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
        view.addSubview(cancelButton)
        
        loginTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(41)
            make.top.equalTo(view).offset(61)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(loginTitleLabel)
            make.trailing.equalTo(view).offset(-41)
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(30)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(usernameTextField)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(40)
            make.leading.trailing.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(5)
            make.leading.equalTo(loginButton)
        }
    }

}
