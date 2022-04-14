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
    
    lazy var todayPageData: BehaviorSubject<ListPageData?> = {
        let subject = BehaviorSubject<ListPageData?>(value: nil)
        
        homeModel
            .map { model -> ListPageData? in
                guard let data = "{}".data(using: .utf8) else { return nil }
                var listPage = try? JSONDecoder().decode(ListPageData.self, from: data)
                
                var sections = [TasksListSection]()
                for othersPage in model?.data?.otherList ?? [] {
                    if var section = othersPage.sections?.first {
                        let completedTasks = section.tasks?.filter {
                            Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.time ?? 0))
                        }
                        if (completedTasks?.count ?? 0) != 0 {
                            section.tasks = completedTasks
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
    
    lazy var importantPageData: BehaviorSubject<ListPageData?> = {
        let subject = BehaviorSubject<ListPageData?>(value: nil)
        
        homeModel
            .map { model -> ListPageData? in
                guard let data = "{}".data(using: .utf8) else { return nil }
                var listPage = try? JSONDecoder().decode(ListPageData.self, from: data)
                
                var sections = [TasksListSection]()
                for othersPage in model?.data?.otherList ?? [] {
                    if var section = othersPage.sections?.first {
                        let completedTasks = section.tasks?.filter {
                            $0.isImportant ?? false
                        }
                        if (completedTasks?.count ?? 0) != 0 {
                            section.tasks = completedTasks
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
    
    lazy var completedPageData: BehaviorSubject<ListPageData?> = {
        let subject = BehaviorSubject<ListPageData?>(value: nil)
        
        homeModel
            .map { model -> ListPageData? in
                guard let data = "{}".data(using: .utf8) else { return nil }
                var listPage = try? JSONDecoder().decode(ListPageData.self, from: data)
                
                var sections = [TasksListSection]()
                for othersPage in model?.data?.otherList ?? [] {
                    if var section = othersPage.sections?.first {
                        let completedTasks = section.tasks?.filter {
                            $0.isCompleted ?? false
                        }
                        if (completedTasks?.count ?? 0) != 0 {
                            section.tasks = completedTasks
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
