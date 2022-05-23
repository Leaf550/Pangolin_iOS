//
//  MineViewController.swift
//  Mine
//
//  Created by 方昱恒 on 2022/5/18.
//

import UIKit
import UIComponents
import Provider
import SnapKit
import Util
import RxSwift
import RxCocoa

class MineViewController: UIViewController {
    
    private let accountService = PGProviderManager.shared.provider(forProtocol: { AccountProvider.self })
    
    private lazy var avatarView: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "avatar")
        avatar.clipsToBounds = true
        avatar.layer.borderWidth = 0.5
        avatar.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.4).cgColor
        
        return avatar
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .textFont(for: .body, weight: .regular)
        
        return label
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .disabled)
        button.titleLabel?.font = .textFont(for: .title3, weight: .regular)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.rx.tap.bind { [weak self] _ in
            (self?.loggedIn ?? false) ? self?.logout() : self?.login()
        }.disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var loggedIn = accountService?.isLogined() ?? false
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshUI()
    }
    
    private func refreshUI() {
        loggedIn = accountService?.isLogined() ?? false
        nicknameLabel.text = loggedIn ? accountService?.getUser()?.username ?? "请登录" : "请登录"
        logInButton.setTitle(loggedIn ? "退出" : "登录", for: .normal)
    }
    
    private func setUpSubViews() {
        title = "我的"
        view.backgroundColor = .systemBackground
        
        view.addSubview(avatarView)
        view.addSubview(nicknameLabel)
        view.addSubview(logInButton)
        
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Screen.totalTopHeight + 40)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        avatarView.layer.cornerRadius = 30
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(20)
            make.centerY.equalTo(avatarView)
        }
        
        logInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0 - Screen.totalBottomHeighr - 40)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    
    private func login() {
        let accountService = PGProviderManager.shared.provider { AccountProvider.self }
        accountService?.presentLoginViewController(
            from: self,
            animated: true,
            presentCompletion: nil,
            loginCompletion: { [weak self] _ in
                self?.refreshUI()
            }
        )
    }
    
    private func logout() {
        let accountService = PGProviderManager.shared.provider { AccountProvider.self }
        accountService?.logout()
        self.refreshUI()
    }

}
