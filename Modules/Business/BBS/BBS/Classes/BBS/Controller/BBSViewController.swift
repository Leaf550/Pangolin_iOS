//
//  BBSViewController.swift
//  BBS
//
//  Created by 方昱恒 on 2022/3/31.
//

import UIKit
import PGFoundation
import SnapKit
import RxSwift

class BBSViewController: UIViewController, ViewController, UITableViewDataSource, UITableViewDelegate {
    
    typealias VM = BBSViewModel
    
    var viewModel = BBSViewModel()
    var disposeBag = DisposeBag()
    
    private var bbsHomeModel: BBSHomeModel?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(BBSTableViewCell.self, forCellReuseIdentifier: BBSTableViewCell.reuseID)
        table.backgroundColor = .systemGroupedBackground
        table.addSubview(refreshControl)
        
        table.dataSource = self
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSubViews()
        bindViewModel()
        onRefresh()
    }
    
    func bindViewModel() {
        let output = viewModel.transformToOutput()
        
        output.bbsHomeRefreshCompleted
            .subscribe(onNext: { [weak self] model in
                self?.refreshControl.endRefreshing()
                self?.bbsHomeModel = model
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func onRefresh() {
        viewModel.input.bbsHomeRefresh.onNext(Void())
    }
    
    private func setUpSubViews() {
        title = "社区"
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
        bbsHomeModel?.data?.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBSTableViewCell.reuseID, for: indexPath) as? BBSTableViewCell
        
        cell?.controller = self
        if let post = bbsHomeModel?.data?.posts?[indexPath.row] {
            cell?.configViews(with: post)
        }
        
        return cell ?? UITableViewCell()
    }
    
}


struct UserImpl: Codable, User {
    var sub: String?
    var username: String?
    var level: Int?
    var experience: Int?
    var exp: Int?
}
