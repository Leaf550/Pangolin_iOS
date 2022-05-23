//
//  NotificationProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/5/21.
//

import PGFoundation

public protocol NotificationProvider: PGProvider {
    func addTaskNotification(task: TaskModel)
    func deleteTaskNotification(_ task: TaskModel)
    func deleteNotification(withIdentifier identifier: String?)
    func deleteAllNotification()
}
