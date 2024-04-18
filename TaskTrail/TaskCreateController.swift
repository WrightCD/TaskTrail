//
//  TaskCreateController.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-04-17.
//

import UIKit
import CoreData

class TaskCreateController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var taskName: UITextField!
    
    @IBOutlet weak var dueDate: UITextField!
    
    @IBOutlet weak var difficulty: UITextField!
    
    @IBOutlet weak var priority: UITextField!
    
    @IBOutlet weak var typeDesc: UITextView!
    
    @IBOutlet weak var taskType: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var taskCategories: [TaskCategory] = []
    var selectedTaskCategory: TaskCategory?
    let difficultyValues = Array(1...5)
    let priorityValues = Array(1...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        taskType.inputView = pickerView
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dueDate.inputView = datePicker
        
        let difficultyPicker = UIPickerView()
        let priorityPicker = UIPickerView()
        difficultyPicker.tag = 0
        priorityPicker.tag = 1
        difficultyPicker.delegate = self
        priorityPicker.delegate = self
        difficulty.inputView = difficultyPicker
        priority.inputView = priorityPicker
               
        // Fetch TaskCategories from Core Data
        fetchTaskCategories()
        
        cancelButton.tintColor = UIColor.red

        // Do any additional setup after loading the view.
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dueDate.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == taskType.inputView as? UIPickerView {
            return taskCategories.count
        } else if pickerView.tag == 0 {
            return difficultyValues.count
        } else {
            return priorityValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == taskType.inputView as? UIPickerView {
            return taskCategories[row].name
        } else if pickerView.tag == 0 {
            return "\(difficultyValues[row])"
        } else {
            return "\(priorityValues[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == taskType.inputView as? UIPickerView {
            selectedTaskCategory = taskCategories[row]
            taskType.text = selectedTaskCategory?.name
            typeDesc.text = "Description: \(selectedTaskCategory?.desc ?? "No description")"
        } else if pickerView.tag == 0 {
            difficulty.text = "\(difficultyValues[row])"
        } else {
            priority.text = "\(priorityValues[row])"
        }
    }
    
    // Fetch TaskCategories from Core Data
    func fetchTaskCategories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: Could not access AppDelegate")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        
        do {
            taskCategories = try managedContext.fetch(fetchRequest)
        } catch {
            print("Error fetching task categories: \(error)")
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        // Validate all fields
        guard let name = taskName.text, !name.isEmpty else {
            showAlert(message: "Please enter a task name")
            return
        }
        guard let dueDateString = dueDate.text, !dueDateString.isEmpty else {
            showAlert(message: "Please select a due date")
            return
        }
        guard let difficultyString = difficulty.text, !difficultyString.isEmpty, let difficultyValue = Int16(difficultyString), difficultyValues.contains(Int(difficultyValue)) else {
                showAlert(message: "Please select a valid difficulty")
                return
        }
        guard let priorityString = priority.text, !priorityString.isEmpty, let priorityValue = Int64(priorityString), priorityValues.contains(Int(priorityValue)) else {
                showAlert(message: "Please select a valid priority")
                return
            }
        guard let selectedCategory = selectedTaskCategory else {
            showAlert(message: "Please select a task category")
            return
        }
            
        // Convert due date string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        guard let dueDate = dateFormatter.date(from: dueDateString) else {
            showAlert(message: "Invalid due date format")
            return
        }
            
        // Create a new Task object
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showAlert(message: "Error accessing Core Data")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else {
            showAlert(message: "Error creating task entity")
            return
        }
        let task = NSManagedObject(entity: taskEntity, insertInto: managedContext)
            
        // Set task properties
        task.setValue(selectedCategory.id, forKeyPath: "category")
        task.setValue(selectedCategory.name, forKeyPath: "catName")
        task.setValue(selectedCategory.color, forKeyPath: "color")
        task.setValue(false, forKeyPath: "completed")
        task.setValue(difficultyValue, forKeyPath: "difficulty")
        task.setValue(dueDate, forKeyPath: "dueDate")
        task.setValue(priorityValue, forKeyPath: "priority")
        task.setValue(taskName.text, forKeyPath: "task")
            
        // Save the task to Core Data
        do {
            try managedContext.save()
            showAlert(message: "Task \(name) has been created.")
                
            // Clear input fields
            taskName.text = ""
            difficulty.text = ""
            priority.text = ""
            taskType.text = ""
            typeDesc.text = ""
        } catch let error as NSError {
            showAlert(message: "Could not save. \(error), \(error.userInfo)")
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    

}
