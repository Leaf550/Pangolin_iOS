//
//  TopTasksListView.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit
import UIComponents
import RxSwift
import RxCocoa

class TopTasksListView: UIView {
    
    var todayTapped = PublishSubject<UITapGestureRecognizer>()
    var importantTapped = PublishSubject<UITapGestureRecognizer>()
    var allTapped = PublishSubject<UITapGestureRecognizer>()
    var completedTapped = PublishSubject<UITapGestureRecognizer>()
    
    private let disposeBag = DisposeBag()
    
    lazy var todayList: TopTasksView = {
        let icon = TasksGroupTinyIcon(image: UIImage(), color: .blue)
        let block = TopTasksView(icon: icon, name: "今天", number: 0)
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(to: todayTapped).disposed(by: disposeBag)
        block.addGestureRecognizer(tap)
        
        return block
    }()
    
    lazy var importantList: TopTasksView = {
        let icon = TasksGroupTinyIcon(image: UIImage(), color: .orange)
        let block = TopTasksView(icon: icon, name: "重要", number: 0)
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(to: importantTapped).disposed(by: disposeBag)
        block.addGestureRecognizer(tap)
        
        return block
    }()
    
    lazy var allList: TopTasksView = {
        let icon = TasksGroupTinyIcon(image: UIImage(), color: .gray)
        let block = TopTasksView(icon: icon, name: "全部", number: 0)
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(to: allTapped).disposed(by: disposeBag)
        block.addGestureRecognizer(tap)
        
        return block
    }()
    
    lazy var completedList: TopTasksView = {
        let icon = TasksGroupTinyIcon(image: UIImage(), color: .green)
        let block = TopTasksView(icon: icon, name: "已完成", number: 0)
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind(to: completedTapped).disposed(by: disposeBag)
        block.addGestureRecognizer(tap)
        
        return block
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(todayList)
        addSubview(importantList)
        addSubview(allList)
        addSubview(completedList)
        
        let distance = 16
        
        todayList.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(distance)
        }
        
        importantList.snp.makeConstraints { make in
            make.top.equalTo(todayList)
            make.leading.equalTo(todayList.snp.trailing).offset(distance)
            make.trailing.equalToSuperview().offset(-distance)
            make.width.equalTo(todayList)
        }
        
        allList.snp.makeConstraints { make in
            make.top.equalTo(todayList.snp.bottom).offset(distance)
            make.leading.equalTo(todayList)
            make.bottom.equalToSuperview().offset(-distance)
        }
        
        completedList.snp.makeConstraints { make in
            make.top.equalTo(allList)
            make.leading.equalTo(allList.snp.trailing).offset(distance)
            make.trailing.equalToSuperview().offset(-distance)
            make.width.equalTo(allList)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
