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
    
    private lazy var deleteTaskAction: PublishSubject<String> = {
        let subject = PublishSubject<String>()
        
        subject
            .withLatestFrom(homeModel) { ($0, $1) }
            .map { taskId, homeModel -> HomeModel? in
                var homeModel = homeModel
                for taskListIndex in 0 ..< (homeModel?.data?.otherList?.count ?? 0) {
                    let has = false
                    if var taskList = homeModel?.data?.otherList?[taskListIndex].sections?[0].tasks {
                        for taskIndex in 0 ..< taskList.count {
                            if taskList[taskIndex].taskID == taskId {
                                taskList.remove(at: taskIndex)
                                homeModel?.data?.otherList?[taskListIndex].sections?[0].tasks = taskList
                                break
                            }
                        }
                    }
                    if has {
                        break
                    }
                }
                return homeModel
            }
            .bind(to: homeModel)
            .disposed(by: disposeBag)
        
        return subject
    }()
    
    private lazy var setImportantAction: PublishSubject<(String, Bool)> = {
        let subject = PublishSubject<(String, Bool)>()
        
        subject
            .withLatestFrom(homeModel) { ($0.0, $0.1, $1) }
            .map { taskId, isImportant, homeModel -> HomeModel? in
                var homeModel = homeModel
                for taskListIndex in 0 ..< (homeModel?.data?.otherList?.count ?? 0) {
                    let has = false
                    if var taskList = homeModel?.data?.otherList?[taskListIndex].sections?[0].tasks {
                        for taskIndex in 0 ..< taskList.count {
                            if taskList[taskIndex].taskID == taskId {
                                taskList[taskIndex].isImportant = isImportant
                                homeModel?.data?.otherList?[taskListIndex].sections?[0].tasks = taskList
                                break
                            }
                        }
                    }
                    if has {
                        break
                    }
                }
                return homeModel
            }
            .bind(to: homeModel)
            .disposed(by: disposeBag)
            
        
        return subject
    }()
    
    func deleteTask(withTaskID taskID: String) {
        deleteTaskAction.onNext(taskID)
    }
    
    func setTaskIsImportant(forTaskId taskId: String, isImportant: Bool) {
        setImportantAction.onNext((taskId, isImportant))
    }
    
}
