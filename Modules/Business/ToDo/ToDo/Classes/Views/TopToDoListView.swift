//
//  TopToDoListView.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit
import UIComponents

class TopToDoListView: UIView {
    
    private lazy var todayList: ToDoBlock = {
        let icon = ToDoTinyIcon(image: UIImage(), color: .blue)
        let block = ToDoBlock(icon: icon, name: "今天", number: 0)
        
        return block
    }()
    
    private lazy var flagList: ToDoBlock = {
        let icon = ToDoTinyIcon(image: UIImage(), color: .orange)
        let block = ToDoBlock(icon: icon, name: "重要", number: 0)
        
        return block
    }()
    
    private lazy var allList: ToDoBlock = {
        let icon = ToDoTinyIcon(image: UIImage(), color: .gray)
        let block = ToDoBlock(icon: icon, name: "全部", number: 0)
        
        return block
    }()
    
    private lazy var finishedList: ToDoBlock = {
        let icon = ToDoTinyIcon(image: UIImage(), color: .green)
        let block = ToDoBlock(icon: icon, name: "已完成", number: 0)
        
        return block
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(todayList)
        addSubview(flagList)
        addSubview(allList)
        addSubview(finishedList)
        
        let distance = 16
        
        todayList.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(distance)
        }
        
        flagList.snp.makeConstraints { make in
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
        
        finishedList.snp.makeConstraints { make in
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
