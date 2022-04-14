//
//  TaskManager.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/4/13.
//

import PGFoundation
import Provider
import RxSwift
import Foundation

class TaskManager {
    
    static let shared = TaskManager()
    
    private let disposeBag = DisposeBag()
    
    var persistenceService = PGProviderManager.shared.provider(forProtocol: { PersistenceProvider.self })
    
    var persistedHomeModel: HomeModel? {
        persistenceService?.getHomeModel()
    }
    
    lazy var homeModel: BehaviorSubject<HomeModel?> = BehaviorSubject<HomeModel?>(value: persistedHomeModel)
    
    lazy var allPageData: BehaviorSubject<ListPageData?> = {
        let subject = BehaviorSubject<ListPageData?>(value: nil)
        
        homeModel
            .map { model -> ListPageData? in
                guard let data = "{}".data(using: .utf8) else { return nil }
                var listPage = try? JSONDecoder().decode(ListPageData.self, from: data)
                
                var sections = [TasksListSection]()
                for othersPage in model?.data?.otherList ?? [] {
                    if let section = othersPage.sections?.first {
                        if (section.tasks?.count ?? 0) != 0 {
                            sections.append(section)
                        }
                    }
                }
                listPage?.sections = sections
                return listPage
            }
            .bind(to: subject)
            .disposed(by: disposeBag)
        
        return subject
    }()
    
}
