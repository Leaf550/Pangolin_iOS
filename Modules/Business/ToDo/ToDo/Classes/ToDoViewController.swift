//
//  ToDoViewController.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import Provider

class ToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testLabel = UILabel()
        testLabel.text = "ToDo"
        testLabel.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        view.addSubview(testLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let accountService = PGProviderManager.shared.provider(forProtocol: { AccountProvider.self })
        
        accountService?.presentLoginViewController(from: self.tabBarController!, animated: true)
    }

}
