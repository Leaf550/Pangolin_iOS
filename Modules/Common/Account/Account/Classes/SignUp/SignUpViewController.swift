//
//  SignUpViewController.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

import UIKit
import PGFoundation
import UIComponents

class SignUpViewController: ViewController<SignUpViewModel>, UITextFieldDelegate {
    
    /**
     闭包参数：是否注册完成
     */
    public var signUpCompletion: (Bool) -> Void = { _ in }
    
    private lazy var signUpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "注册"
        label.textColor = .label
        label.font = .textFont(for: .largeTitle, weight: .regular)
        
        return label
    }()
    
    private lazy var usernameTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "起个名字吧～"
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var usernameWariningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .textFont(for: .caption1, weight: .regular)
        
        return label
    }()
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "设置一个密码"
        textField.isSecureTextEntry = true
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var passwordWariningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .textFont(for: .caption1, weight: .regular)
        
        return label
    }()
    
    private lazy var repeatePasswordTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "再次输入密码"
        textField.isSecureTextEntry = true
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var repeatePasswordWariningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .textFont(for: .caption1, weight: .regular)
        
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("注册", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .disabled)
        button.titleLabel?.font = .textFont(for: .title3, weight: .regular)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("我再想想...", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .textFont(for: .caption1, weight: .regular)
        
        button.rx.tap.subscribe { [weak self] _ in
            self?.dismiss(animated: true) { [weak self] in
                self?.signUpCompletion(false)
            }
        }.disposed(by: disposeBag)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSubviews()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        repeatePasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.input.repeatedPassword)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.input.signUpButtonTap)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.usernameValied
            .subscribe(onNext: { [weak self] valied in
                self?.usernameWariningLabel.text = valied ? "" : "用户名长度需要在6～12位以内"
            })
            .disposed(by: disposeBag)
        
        output.passwordValied
            .subscribe(onNext: { [weak self] valied in
                self?.passwordWariningLabel.text = valied ? "" : "密码长度需要在6～16位以内"
            })
            .disposed(by: disposeBag)
        
        output.repeatePasswordValied
            .subscribe(onNext: { [weak self] valied in
                self?.repeatePasswordWariningLabel.text = valied ? "" : "两次输入的密码不一样哦～"
            })
            .disposed(by: disposeBag)
        
        output.signUpButtonEnabled
            .asDriver()
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.signUpResult
            .subscribe(onNext: { [weak self] response in
                guard let response = response else {
                    Toast.show(text: "请求失败")
                    return
                }
                
                if response.status == SignUpStatusCode.userExisted.rawValue {
                    Toast.show(text: "该用户名已经注册过了～")
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
                        self?.signUpCompletion(true)
                    }
                }
            })
            .disposed(by: disposeBag)
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

}

// MARK: - UI Layout
extension SignUpViewController {
    private func setUpSubviews() {
        view.addSubview(signUpTitleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameWariningLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordWariningLabel)
        view.addSubview(repeatePasswordTextField)
        view.addSubview(repeatePasswordWariningLabel)
        view.addSubview(signUpButton)
        view.addSubview(cancelButton)
        
        signUpTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(41)
            make.top.equalTo(view).offset(61)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(signUpTitleLabel)
            make.trailing.equalTo(view).offset(-41)
            make.top.equalTo(signUpTitleLabel.snp.bottom).offset(30)
            make.height.equalTo(44)
        }
        
        usernameWariningLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom)
            make.leading.equalTo(usernameTextField)
            make.height.equalTo(15)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameWariningLabel.snp.bottom).offset(5)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        
        passwordWariningLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.height.equalTo(15)
        }
        
        repeatePasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordWariningLabel.snp.bottom).offset(5)
            make.leading.trailing.height.equalTo(passwordTextField)
        }
        
        repeatePasswordWariningLabel.snp.makeConstraints { make in
            make.top.equalTo(repeatePasswordTextField.snp.bottom)
            make.leading.equalTo(repeatePasswordTextField)
            make.height.equalTo(15)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(repeatePasswordWariningLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(repeatePasswordTextField)
            make.height.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(5)
            make.leading.equalTo(signUpButton)
        }
        
    }
}
