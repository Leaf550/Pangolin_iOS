//
//  BBSViewController.swift
//  BBS
//
//  Created by 方昱恒 on 2022/3/31.
//

import UIKit
import PGFoundation
import SnapKit

class BBSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(BBSTableViewCell.self, forCellReuseIdentifier: BBSTableViewCell.reuseID)
        table.backgroundColor = .systemBackground
        
        table.dataSource = self
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSubViews()
    }
    
    private func setUpSubViews() {
        self.title = "xxx社区"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension BBSViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBSTableViewCell.reuseID, for: indexPath) as? BBSTableViewCell
        
        
        return cell ?? UITableViewCell()
    }
    
}


struct UserImpl: User {
    var sub: String?
    var username: String?
    var level: Int?
    var experience: Int?
    var exp: Int?
}
