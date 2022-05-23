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
    
    let persistenceService = PGProviderManager.shared.provider(forProtocol: { PersistenceProvider.self })
    let notificationService = PGProviderManager.shared.provider { NotificationProvider.self }
    
    var persistedHomeModel: HomeModel? {
        persistenceService?.getHomeModel()
    }
    
    lazy var homeModel: BehaviorSubject<HomeModel?> = {
        let subject = BehaviorSubject<HomeModel?>(value: persistedHomeModel)
        subject.subscribe(onNext: { [weak self] homeModel in
            guard let homeModel = homeModel else {
                self?.notificationService?.deleteAllNotification()
                return
            }
            _ = self?.persistenceService?.saveHomeModel(homeModel)
            self?.configNotifications(withHomeModel: homeModel)
        })
        .disposed(by: disposeBag)
        
        return subject
    }()
    
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
    
    private lazy var addTaskAction: PublishSubject<(TaskModel, String)> = {
        let subject = PublishSubject<(TaskModel, String)>()
        subject
            .withLatestFrom(homeModel) { ($0.0, $0.1, $1) }
            .map { task, listId, homeModel -> HomeModel? in
                var homeModel = homeModel
                for pageIndex in 0 ..< (homeModel?.data?.otherList?.count ?? 0) {
                    if var taskList = homeModel?.data?.otherList?[pageIndex].sections?[0].taskList,
                       taskList.listID == listId {
                        homeModel?.data?.otherList?[pageIndex].sections?[0].tasks?.append(task)
                        let sortedTask = homeModel?.data?.otherList?[pageIndex].sections?[0].tasks?
                            .sorted { ($0.createTime ?? 0) < ($1.createTime ?? 0) }
                        homeModel?.data?.otherList?[pageIndex].sections?[0].tasks = sortedTask
                    }
                }
                return homeModel
            }
            .bind(to: homeModel)
            .disposed(by: disposeBag)
        
        return subject
    }()
    
    private lazy var addTaskListAction: PublishSubject<TaskList> = {
        let subject = PublishSubject<TaskList>()
        subject
            .withLatestFrom(homeModel) { ($0, $1) }
            .map { taskList, homeModel -> HomeModel? in
                var homeModel = homeModel
                
                guard let data = "{}".data(using: .utf8) else { return homeModel }
                guard var listPage = try? JSONDecoder().decode(ListPageData.self, from: data) else {
                    return homeModel
                }
                guard var section = try? JSONDecoder().decode(TasksListSection.self, from: data) else { return homeModel
                }
                section.taskList = taskList
                listPage.sections = [TasksListSection]()
                listPage.sections?.append(section)
                homeModel?.data?.otherList?.append(listPage)
                
                return homeModel
            }
            .bind(to: homeModel)
            .disposed(by: disposeBag)
        
        return subject
    }()
    
    private lazy var sharedTaskAction: PublishSubject<String> = {
        let publish = PublishSubject<String>()
        publish
            .withLatestFrom(homeModel) { ($0, $1) }
            .map { taskId, homeModel -> HomeModel? in
                var homeModel = homeModel
                for listIndex in 0 ..< (homeModel?.data?.otherList?.count ?? 0) {
                    var has = false
                    for taskIndex in 0 ..< (homeModel?.data?.otherList?[listIndex].sections?[0].tasks?.count ?? 0) {
                        if taskId == (homeModel?.data?.otherList?[listIndex].sections?[0].tasks?[taskIndex].taskID ?? "") {
                            homeModel?.data?.otherList?[listIndex].sections?[0].tasks?[taskIndex].shared = true
                            has = true
                            break
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
        
        return publish
    }()
    
    func deleteTask(withTaskID taskID: String) {
        deleteTaskAction.onNext(taskID)
    }
    
    func setTaskIsImportant(forTaskId taskId: String, isImportant: Bool) {
        setImportantAction.onNext((taskId, isImportant))
    }
    
    func addTask(task: TaskModel, toListID listID: String) {
        addTaskAction.onNext((task, listID))
    }
    
    func addTaskList(taskList: TaskList) {
        addTaskListAction.onNext(taskList)
    }
    
    func shareTask(taskId: String) {
        sharedTaskAction.onNext(taskId)
    }
    
    private func configNotifications(withHomeModel homeModel: HomeModel) {
        for pageData in homeModel.data?.otherList ?? [] {
            for section in pageData.sections ?? [] {
                for task in section.tasks ?? [] {
                    notificationService?.deleteTaskNotification(task)
                    if !(task.isCompleted ?? false) {
                        notificationService?.addTaskNotification(task: task)
                    }
                }
            }
        }
    }
    
}
