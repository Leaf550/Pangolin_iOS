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

class LoginViewController: ViewController<LoginViewModel> {
    
    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "登录"
        label.textColor = .label
        label.font = .textFont(for: .largeTitle, weight: .regular)
        
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请填写用户名"
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请填写密码"
        textField.isSecureTextEntry = true
        textField.textColor = .label
        textField.font = .textFont(for: .body, weight: .regular)
        
        return textField
    }()
    
    private lazy var signUpHintLabel: UILabel = {
        let label = UILabel()
        label.text = "还没有注册？"
        label.textColor = .label
        label.font = .textFont(for: .caption1, weight: .regular)
        
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("点击这里！", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .textFont(for: .caption1, weight: .regular)
        
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .textFont(for: .title3, weight: .regular)
        button.backgroundColor = .systemBlue
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        view.addSubview(loginTitleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpHintLabel)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
        
        loginTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(41)
            make.top.equalTo(view).offset(Screen.statusBarHeight + 30)
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
        
        signUpHintLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.height.equalTo(signUpHintLabel)
            make.leading.equalTo(signUpHintLabel.snp.trailing)
        }
        
        loginButton.layer.cornerRadius = 4
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(60)
            make.leading.trailing.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
    }

}
