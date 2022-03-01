//
//  ToDoViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import Provider
import RxSwift
import RxCocoa

class ToDoViewController: UIViewController {
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        view.addSubview(button)
        
        button.rx.tap.subscribe(onNext: { _ in
            let accountService = PGProviderManager.shared.provider(forProtocol: { AccountProvider.self })
            accountService?.presentLoginViewController(from: self.tabBarController!, animated: true)
        }).disposed(by: disposeBag)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

}
