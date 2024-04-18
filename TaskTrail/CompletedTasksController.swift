//
//  CompletedTasksController.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-04-16.
//

import UIKit
import CoreData

class CompletedTasksController: UIViewController, UITableViewDataSource, CompletedCellDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedTask = completedTasks[indexPath.row]
        let cell = taskTable.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath) as! CompletedCell
        cell.taskName.text = selectedTask.task
        cell.category.text = selectedTask.catName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let compDate = selectedTask.compDate {
            cell.compDate.text = "Completed on: \(dateFormatter.string(from: compDate))"
        } else {
            cell.compDate.text = "Completion date not logged"
        }
        cell.delegate = self
        return cell
    }
    
    
    @IBOutlet weak var taskTable: UITableView!
    
    var completedTasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTable.dataSource = self
        taskTable.rowHeight = 100
        
        // Fetch completed tasks from CoreData where completed is true
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
        
        do {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                completedTasks = try context.fetch(fetchRequest)
                taskTable.reloadData()
            }
        } catch {
            print("Error fetching completed tasks: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }

    func deleteButtonTapped(cell: CompletedCell) {
        guard let indexPath = taskTable.indexPath(for: cell) else { return }
        let taskToDelete = completedTasks[indexPath.row]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(taskToDelete)
            
            completedTasks.remove(at: indexPath.row)
            taskTable.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
