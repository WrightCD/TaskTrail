//
//  TrailTask.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-03-25.
//

import Foundation

class TrailTask {
    var id: Int
    var task: String
    var dueDate: Date
    var category: TrailCategory
    var priority: Int
    var completed: Bool

    init(id: Int, task: String, dueDate: Date, category: TrailCategory, priority: Int, completed: Bool) {
        self.id = id
        self.task = task
        self.dueDate = dueDate
        self.category = category
        self.priority = priority
        self.completed = completed
    }
}