//
//  NotificationModule.swift
//  Notification
//
//  Created by 方昱恒 on 2022/5/21.
//

import PGFoundation
import Provider

class NotificationModule: PGModule {
    
    static var shared: PGModule = NotificationModule()
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ NotificationProvider.self }, self)
        
        requestNotificationAuthorization()
    }
    
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in }
    }
    
}

extension NotificationModule: NotificationProvider {
    
    func addTaskNotification(task: TaskModel) {
        if task.date == nil {
            return
        } else if let taskDate = task.date, task.time == nil {
            // 头天晚上9点推送消息
            configNotificationRequest(timeStamp: taskDate - 3 * 3600, title: "明天有任务截止啦！别忘了嗷～～", task: task, identifier: (task.taskID ?? "\(UUID().uuidString)") + "dateOnly")
        } else if task.date != nil, let taskTime = task.time {
            // 提前10分钟推送消息
            configNotificationRequest(timeStamp: taskTime - 10 * 60, title: "有一项任务还有10分钟到期了哦～", task: task, identifier: task.taskID ?? "\(UUID().uuidString)" + "preNotif")
            configNotificationRequest(timeStamp: taskTime, title: "有一项任务到期了哇...", task: task, identifier: (task.taskID ?? "\(UUID().uuidString)") + "deadlien")
        }
    }
    
    func deleteTaskNotification(_ task: TaskModel) {
        guard let taskID = task.taskID else { return }
        
        deleteNotification(withIdentifier: taskID + "dateOnly")
        deleteNotification(withIdentifier: taskID + "preNotif")
        deleteNotification(withIdentifier: taskID + "deadlien")
    }
    
    func deleteNotification(withIdentifier identifier: String?) {
        guard let identifier = identifier else { return }

        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func deleteAllNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func configNotificationRequest(timeStamp: TimeInterval, title: String, task: TaskModel, identifier: String) {
        let timeInterval = Date(timeIntervalSince1970: timeStamp).timeIntervalSinceNow
        if timeInterval <= 0 {
            return
        }
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        var notificationBody = task.title ?? ""
        notificationBody += task.comment == nil ? "" : "\n\(task.comment ?? "")"
        if notificationBody.isEmpty {
            return
        }
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = notificationBody
        notificationContent.sound = .default
        
        let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(notificationRequest)
    }
    
}
