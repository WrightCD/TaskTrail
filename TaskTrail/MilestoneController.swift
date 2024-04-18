//
//  MilestoneController.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-04-16.
//

import UIKit
import CoreData

class MilestoneController: UIViewController{
    
    @IBOutlet weak var words: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCompletionStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCompletionStatus()
    }
    
    func updateCompletionStatus() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
        
        do {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let completedCount = try context.count(for: fetchRequest)
                if completedCount > 0 {
                    words.text = "Congratulations! You have completed \(completedCount) tasks. Keep up the great work!"
                }
                else if completedCount == 1 {
                    words.text = "Congratulations! You have completed \(completedCount) task. Keep up the great work!"
                }else {
                    words.text = "Congratulations! You made a great decision with this app. Try to complete a task to continue the momentum."
                }
            }
        } catch {
            print("Error fetching completed tasks count: \(error)")
        }
    }

}
