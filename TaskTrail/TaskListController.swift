//
//  ViewController.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-02-27.
//  100875122

import UIKit
import CoreData

class TaskListController: UIViewController, UITableViewDataSource, TableViewTaskCellDelegate{
    
    @IBOutlet weak var taskTable: UITableView!
    
    var tasks: [Task] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        taskTable.dataSource = self
        taskTable.rowHeight = 100
        
        // Fetch tasks from CoreData where completed is false
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        
        do {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                tasks = try context.fetch(fetchRequest)
                taskTable.reloadData()
            }
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TableViewTaskCell
        cell.delegate = self
        let task = tasks[indexPath.row]
        cell.taskName.text = task.task
        cell.priority.text = "\(task.priority)"
        cell.category.text = task.catName
        cell.colorDisplay.tintColor = colorForName(task.color ?? "")
        cell.difficulty.tintColor = colorForDiff(Int(task.difficulty))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let dueDate = task.dueDate {
            cell.dueDate.text = dateFormatter.string(from: dueDate)
        } else {
            cell.dueDate.text = ""
        }
        return cell
    }
    
    func deleteButtonTapped(cell: TableViewTaskCell) {
        guard let indexPath = taskTable.indexPath(for: cell) else { return }
        let taskToDelete = tasks[indexPath.row]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(taskToDelete)
            
            tasks.remove(at: indexPath.row)
            taskTable.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func checkmarkButtonTapped(cell: TableViewTaskCell) {
        guard let indexPath = taskTable.indexPath(for: cell) else { return }
        let task = tasks[indexPath.row]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            task.completed = !task.completed
            task.compDate = Date()
            
            do {
                try context.save()
                
                // Remove the task from the lists
                tasks.remove(at: indexPath.row)
                taskTable.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    //Colours for the smiley face
    func colorForDiff(_ difficulty: Int) -> UIColor{
        switch difficulty{
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.green
        case 3:
            return UIColor.yellow
        case 4:
            return UIColor.orange
        case 5:
            return UIColor.red
        default:
            return UIColor.yellow
        }
    }
    
    //Colours for the stub
    func colorForName(_ name: String) -> UIColor {
        switch name.lowercased() {
        case "red":
            return UIColor.red
        case "green":
            return UIColor.green
        case "blue":
            return UIColor.blue
        case "yellow":
            return UIColor.yellow
        case "orange":
            return UIColor.orange
        case "purple":
            return UIColor.purple
        case "pink":
            return UIColor.systemPink
        case "brown":
            return UIColor.brown
        case "cyan":
            return UIColor.cyan
        case "magenta":
            return UIColor.magenta
        case "teal":
            if #available(iOS 13.0, *) {
                return UIColor.systemTeal
            } else {
                return UIColor.blue
            }
        case "gray":
            return UIColor.gray
        default:
            return UIColor.black
        }
        
        
        
        
    }
}
